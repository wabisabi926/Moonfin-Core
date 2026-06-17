import 'dart:async';
import 'dart:convert';

import 'package:server_core/server_core.dart';

import '../database/search_database.dart';
import 'embedding_service.dart';

class CatalogSyncService {
  CatalogSyncService(this._db, this._client, this._embeddingService);

  final SearchDatabase _db;
  final MediaServerClient _client;
  final EmbeddingService _embeddingService;

  static const _syncItemTypes = <String>['Movie', 'Series', 'Episode'];
  static const _catalogFields =
      'Type,UserData,ProductionYear,SeriesName,ParentIndexNumber,IndexNumber,'
      'ImageTags,BackdropImageTags,ParentBackdropItemId,ParentBackdropImageTags,'
      'SeriesId,SeriesPrimaryImageTag,Overview,Genres,People,ProviderIds,'
      'CommunityRating,OfficialRating,RunTimeTicks,ServerId,DateCreated';

  static const _pageSize = 200;
  static const _incrementalPages = 3;
  static const _similarLimit = 12;
  static const _similarSyncBudget = 120;
  static const _minSyncInterval = Duration(minutes: 15);
  static const _maxFullSyncAge = Duration(hours: 24);

  Future<void>? _activeSync;

  String get activeServerKey {
    final normalizedBase = _client.baseUrl.trim().toLowerCase();
    final userId = (_client.userId ?? 'anonymous').trim();
    return '$normalizedBase::$userId';
  }

  Future<void> syncIfStale({bool force = false}) {
    final inFlight = _activeSync;
    if (inFlight != null) return inFlight;

    final future = _syncIfNeeded(force: force);
    _activeSync = future;

    return future.whenComplete(() {
      if (identical(_activeSync, future)) {
        _activeSync = null;
      }
    });
  }

  Future<void> _syncIfNeeded({required bool force}) async {
    final serverKey = activeServerKey;
    final state = await _db.getSyncState(serverKey);
    final now = DateTime.now();

    if (!force && state?.lastSyncAt != null) {
      final age = now.difference(state!.lastSyncAt!);
      if (age < _minSyncInterval) {
        return;
      }
    }

    final shouldFullSync =
        force ||
        state == null ||
        state.lastFullSyncAt == null ||
        now.difference(state.lastFullSyncAt!) >= _maxFullSyncAge;

    if (shouldFullSync) {
      await _runFullSync(serverKey);
      return;
    }

    try {
      await _runIncrementalSync(serverKey, state);
    } catch (_) {
      await _runFullSync(serverKey);
    }
  }

  Future<void> _runFullSync(String serverKey) async {
    var startIndex = 0;
    final seenIds = <String>{};
    final similarCandidates = <String>[];

    while (true) {
      final response = await _client.itemsApi.getItems(
        includeItemTypes: _syncItemTypes,
        recursive: true,
        startIndex: startIndex,
        limit: _pageSize,
        fields: _catalogFields,
        sortBy: 'SortName',
        sortOrder: 'Ascending',
        enableTotalRecordCount: true,
      );

      final page = response['Items'] as List? ?? const [];
      if (page.isEmpty) break;

      final entries = <CatalogIndexEntry>[];
      for (final raw in page) {
        if (raw is! Map<String, dynamic>) continue;
        final entry = _toCatalogIndexEntry(serverKey, raw);
        if (entry == null) continue;
        entries.add(entry);
      }

      await _db.upsertCatalogEntries(entries);
      await _syncEmbeddings(serverKey, entries);

      for (final entry in entries) {
        seenIds.add(entry.itemId);
        if (similarCandidates.length < _similarSyncBudget) {
          similarCandidates.add(entry.itemId);
        }
      }

      startIndex += page.length;
      if (page.length < _pageSize) break;
    }

    await _db.removeCatalogEntriesNotIn(serverKey, seenIds);
    await _syncSimilarItems(serverKey, similarCandidates);

    final totalItems = await _db.countCatalogEntries(serverKey);
    final now = DateTime.now();
    await _db.upsertSyncState(
      serverKey: serverKey,
      lastSyncAt: now,
      lastFullSyncAt: now,
      totalItems: totalItems,
    );
  }

  Future<void> _runIncrementalSync(
    String serverKey,
    CatalogSyncState state,
  ) async {
    final touchedIds = <String>[];

    for (var pageIndex = 0; pageIndex < _incrementalPages; pageIndex++) {
      final response = await _client.itemsApi.getItems(
        includeItemTypes: _syncItemTypes,
        recursive: true,
        startIndex: pageIndex * _pageSize,
        limit: _pageSize,
        fields: _catalogFields,
        sortBy: 'DateCreated',
        sortOrder: 'Descending',
      );

      final page = response['Items'] as List? ?? const [];
      if (page.isEmpty) break;

      final entries = <CatalogIndexEntry>[];
      for (final raw in page) {
        if (raw is! Map<String, dynamic>) continue;
        final entry = _toCatalogIndexEntry(serverKey, raw);
        if (entry == null) continue;
        entries.add(entry);
      }

      if (entries.isEmpty) continue;

      await _db.upsertCatalogEntries(entries);
      await _syncEmbeddings(serverKey, entries);
      touchedIds.addAll(entries.map((entry) => entry.itemId));

      if (page.length < _pageSize) break;
    }

    await _syncSimilarItems(
      serverKey,
      touchedIds.take(_similarSyncBudget).toList(),
    );

    final totalItems = await _db.countCatalogEntries(serverKey);
    await _db.upsertSyncState(
      serverKey: serverKey,
      lastSyncAt: DateTime.now(),
      lastFullSyncAt: state.lastFullSyncAt,
      totalItems: totalItems,
    );
  }

  Future<void> _syncEmbeddings(
    String serverKey,
    List<CatalogIndexEntry> entries,
  ) async {
    if (entries.isEmpty) return;

    final embeddings = <CatalogEmbeddingEntry>[];
    for (final entry in entries) {
      final textBlob = _buildEmbeddingText(entry);
      final vector = await _embeddingService.embedText(textBlob);
      if (vector == null) continue;

      embeddings.add(
        CatalogEmbeddingEntry(
          itemId: entry.itemId,
          serverKey: serverKey,
          embedding: _embeddingService.toBytes(vector),
        ),
      );
    }

    await _db.upsertEmbeddings(embeddings);
  }

  Future<void> _syncSimilarItems(
    String serverKey,
    List<String> sourceItemIds,
  ) async {
    if (sourceItemIds.isEmpty) return;

    for (final itemId in sourceItemIds.take(_similarSyncBudget)) {
      try {
        final response = await _client.itemsApi.getSimilarItems(
          itemId,
          limit: _similarLimit,
        );
        final items = response['Items'] as List? ?? const [];

        final similarEntries = <CatalogSimilarEntry>[];
        for (var i = 0; i < items.length; i++) {
          final raw = items[i];
          if (raw is! Map<String, dynamic>) continue;
          final similarId = raw['Id'] as String?;
          if (similarId == null || similarId.isEmpty) continue;

          final score =
              (raw['SimilarityScore'] as num?)?.toDouble() ??
              (_similarLimit - i) / _similarLimit;

          similarEntries.add(
            CatalogSimilarEntry(
              mediaId: itemId,
              serverKey: serverKey,
              similarId: similarId,
              similarServerKey: serverKey,
              score: score,
            ),
          );
        }

        await _db.replaceSimilarItems(
          mediaId: itemId,
          serverKey: serverKey,
          similarEntries: similarEntries,
        );
      } catch (_) {
        // Keep sync resilient: failures for a single item's related list
        // should not fail the whole catalog sync.
      }
    }
  }

  CatalogIndexEntry? _toCatalogIndexEntry(
    String serverKey,
    Map<String, dynamic> raw,
  ) {
    final itemId = raw['Id'] as String?;
    if (itemId == null || itemId.isEmpty) return null;

    final title = (raw['Name'] as String?)?.trim() ?? '';
    if (title.isEmpty) return null;

    final providerIds =
        (raw['ProviderIds'] as Map?)?.cast<String, dynamic>() ?? const {};
    final people = raw['People'] as List? ?? const [];
    final genres =
        (raw['Genres'] as List?)?.whereType<String>().toList() ?? const [];

    final actors = <String>[];
    final directors = <String>[];

    for (final personRaw in people) {
      if (personRaw is! Map) continue;
      final person = personRaw.cast<String, dynamic>();
      final name = (person['Name'] as String?)?.trim();
      if (name == null || name.isEmpty) continue;

      final type = (person['Type'] as String?)?.toLowerCase() ?? '';
      final role = (person['Role'] as String?)?.toLowerCase() ?? '';

      if (type == 'director' || role == 'director') {
        directors.add(name);
      } else if (type == 'actor' || role == 'actor') {
        actors.add(name);
      }
    }

    final serverItemId = (raw['ServerId'] as String?)?.trim().isNotEmpty == true
        ? (raw['ServerId'] as String).trim()
        : serverKey;

    final rawData = Map<String, dynamic>.from(raw)
      ..['Id'] = itemId
      ..['Name'] = title
      ..putIfAbsent('ServerId', () => serverItemId);

    final communityRating = (raw['CommunityRating'] as num?)?.toDouble();

    return CatalogIndexEntry(
      itemId: itemId,
      serverKey: serverKey,
      itemServerId: serverItemId,
      title: title,
      itemType: raw['Type'] as String?,
      overview: (raw['Overview'] as String?)?.trim(),
      productionYear: _toInt(raw['ProductionYear']),
      communityRating: communityRating,
      officialRating: raw['OfficialRating'] as String?,
      runTimeTicks: _toInt(raw['RunTimeTicks']),
      genresText: genres.map((value) => value.toLowerCase()).join(' | '),
      actorsText: actors.map((value) => value.toLowerCase()).join(' | '),
      directorsText: directors.map((value) => value.toLowerCase()).join(' | '),
      tmdbId: providerIds['Tmdb']?.toString(),
      imdbId: providerIds['Imdb']?.toString(),
      rawDataJson: jsonEncode(rawData),
      popularityScore: communityRating ?? 0.0,
    );
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  String _buildEmbeddingText(CatalogIndexEntry entry) {
    final parts = <String>[
      entry.title,
      entry.itemType ?? '',
      if (entry.productionYear != null) '${entry.productionYear}',
      entry.overview ?? '',
      entry.genresText.replaceAll('|', ' '),
      entry.actorsText.replaceAll('|', ' '),
      entry.directorsText.replaceAll('|', ' '),
    ];

    return parts.where((value) => value.trim().isNotEmpty).join(' ');
  }
}
