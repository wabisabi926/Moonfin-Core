import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../database/search_database.dart';
import '../models/aggregated_item.dart';
import '../repositories/mdblist_repository.dart';
import 'catalog_sync_service.dart';
import 'embedding_service.dart';
import 'query_parser.dart';

class LocalSearchResult {
  final ParsedQuery parsedQuery;
  final List<AggregatedItem> items;
  final bool preferLocalOnly;

  const LocalSearchResult({
    required this.parsedQuery,
    required this.items,
    required this.preferLocalOnly,
  });

  factory LocalSearchResult.empty(String query) {
    return LocalSearchResult(
      parsedQuery: ParsedQuery(originalQuery: query, semanticQuery: query),
      items: const [],
      preferLocalOnly: false,
    );
  }
}

class LocalMediaSearchService {
  LocalMediaSearchService(
    this._db,
    this._syncService,
    this._queryParser,
    this._mdbListRepository,
    this._embeddingService,
  );

  final SearchDatabase _db;
  final CatalogSyncService _syncService;
  final QueryParser _queryParser;
  final MdbListRepository _mdbListRepository;
  final EmbeddingService _embeddingService;

  static const int _defaultLimit = 48;

  Future<LocalSearchResult> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return LocalSearchResult.empty(query);

    final serverKey = _syncService.activeServerKey;
    await _ensureCatalogReady(serverKey);

    final parsed = _queryParser.parse(trimmed);
    final resultLimit = _normalizeLimit(parsed.resultLimit ?? _defaultLimit);

    final metadataMatches = parsed.hasStructuredFilters
        ? await _db.searchMetadata(
            serverKey: serverKey,
            itemTypes: parsed.itemTypes,
            genres: parsed.genres,
            actors: parsed.actors,
            directors: parsed.directors,
            yearStart: parsed.yearStart,
            yearEnd: parsed.yearEnd,
            sortByRatingDesc:
                parsed.sortField == SearchSortField.rating &&
                parsed.sortOrder != SearchSortOrder.asc,
            limit: resultLimit * 2,
          )
        : const <CatalogIndexItem>[];

    final semanticOrRaw = parsed.semanticQuery.isNotEmpty
        ? parsed.semanticQuery
        : trimmed;
    final ftsQuery = _toFtsQuery(semanticOrRaw);

    List<CatalogSearchHit> ftsHits = const [];
    if (ftsQuery.isNotEmpty) {
      try {
        ftsHits = await _db.searchFts(
          serverKey: serverKey,
          ftsQuery: ftsQuery,
          limit: resultLimit * 2,
        );
      } catch (_) {
        // Invalid FTS syntax should not break search.
      }
    }

    final scored = <String, _ScoredSearchItem>{};
    final externalRatings = <String, double>{};

    for (final item in metadataMatches) {
      final key = '${item.serverKey}:${item.itemId}';
      final score = _metadataScore(item, parsed);
      final current = scored[key];
      if (current == null || score > current.score) {
        scored[key] = _ScoredSearchItem(item, score);
      }
    }

    for (final hit in ftsHits) {
      final key = '${hit.item.serverKey}:${hit.item.itemId}';
      final score = 0.25 + (hit.score * 0.75);
      final current = scored[key];
      if (current == null) {
        scored[key] = _ScoredSearchItem(hit.item, score);
      } else {
        scored[key] = _ScoredSearchItem(current.item, current.score + score);
      }
    }

    await _applySemanticScores(
      scored: scored,
      serverKey: serverKey,
      query: semanticOrRaw,
      resultLimit: resultLimit,
    );

    await _applyExternalRatingScores(
      scored: scored,
      parsed: parsed,
      externalRatings: externalRatings,
      resultLimit: resultLimit,
    );

    final ranked = scored.values.toList()
      ..sort((a, b) {
        if (parsed.ratingSourceKey != null) {
          final aKey = '${a.item.serverKey}:${a.item.itemId}';
          final bKey = '${b.item.serverKey}:${b.item.itemId}';
          final externalCompare = (externalRatings[bKey] ?? -1).compareTo(
            externalRatings[aKey] ?? -1,
          );
          if (externalCompare != 0) {
            return externalCompare;
          }
        }

        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;
        return _tieBreak(a.item, b.item, parsed);
      });

    final items = ranked
        .take(resultLimit)
        .map((entry) => _toAggregatedItem(entry.item))
        .toList();

    return LocalSearchResult(
      parsedQuery: parsed,
      items: items,
      preferLocalOnly: parsed.hasStructuredFilters,
    );
  }

  Future<List<AggregatedItem>> moreLikeThis(
    String mediaId, {
    int limit = 24,
  }) async {
    if (mediaId.trim().isEmpty) return const [];

    final serverKey = _syncService.activeServerKey;
    await _ensureCatalogReady(serverKey);

    final rows = await _db.getSimilarItems(
      serverKey: serverKey,
      mediaId: mediaId,
      limit: _normalizeLimit(limit),
    );

    return rows.map(_toAggregatedItem).toList();
  }

  Future<void> _ensureCatalogReady(String serverKey) async {
    final hasEntries = await _db.hasCatalogEntries(serverKey);
    if (!hasEntries) {
      await _syncService.syncIfStale(force: true);
      return;
    }

    // Keep local index fresh without blocking each query.
    unawaited(_syncService.syncIfStale());
  }

  AggregatedItem _toAggregatedItem(CatalogIndexItem item) {
    Map<String, dynamic> rawData;
    try {
      final decoded = jsonDecode(item.rawDataJson);
      if (decoded is Map<String, dynamic>) {
        rawData = Map<String, dynamic>.from(decoded);
      } else {
        rawData = <String, dynamic>{};
      }
    } catch (_) {
      rawData = <String, dynamic>{};
    }

    rawData['Id'] ??= item.itemId;
    rawData['ServerId'] ??= item.itemServerId;
    rawData['Name'] ??= item.title;
    rawData['Type'] ??= item.itemType;
    rawData['Overview'] ??= item.overview;
    rawData['ProductionYear'] ??= item.productionYear;
    rawData['CommunityRating'] ??= item.communityRating;
    rawData['OfficialRating'] ??= item.officialRating;
    rawData['RunTimeTicks'] ??= item.runTimeTicks;

    return AggregatedItem(
      id: item.itemId,
      serverId: item.itemServerId,
      rawData: rawData,
    );
  }

  int _tieBreak(CatalogIndexItem a, CatalogIndexItem b, ParsedQuery parsed) {
    if (parsed.sortField == SearchSortField.rating) {
      final ratingCompare = (b.communityRating ?? 0.0).compareTo(
        a.communityRating ?? 0.0,
      );
      if (ratingCompare != 0) return ratingCompare;
    }

    if (parsed.sortField == SearchSortField.year) {
      final yearCompare = (b.productionYear ?? 0).compareTo(
        a.productionYear ?? 0,
      );
      if (yearCompare != 0) {
        final descending = parsed.sortOrder != SearchSortOrder.asc;
        return descending ? yearCompare : -yearCompare;
      }
    }

    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  }

  double _metadataScore(CatalogIndexItem item, ParsedQuery parsed) {
    var score = 0.35;

    if (parsed.itemTypes.isNotEmpty &&
        parsed.itemTypes.contains(item.itemType)) {
      score += 0.2;
    }

    if (parsed.yearStart != null && item.productionYear != null) {
      if (item.productionYear! >= parsed.yearStart!) {
        score += 0.1;
      }
    }

    if (parsed.yearEnd != null && item.productionYear != null) {
      if (item.productionYear! <= parsed.yearEnd!) {
        score += 0.1;
      }
    }

    final genreText = item.genresText;
    for (final genre in parsed.genres) {
      if (genreText.contains(genre.toLowerCase())) {
        score += 0.08;
      }
    }

    final actorText = item.actorsText;
    for (final actor in parsed.actors) {
      if (actorText.contains(actor.toLowerCase())) {
        score += 0.1;
      }
    }

    final directorText = item.directorsText;
    for (final director in parsed.directors) {
      if (directorText.contains(director.toLowerCase())) {
        score += 0.12;
      }
    }

    score += ((item.communityRating ?? 0.0) / 10.0) * 0.1;
    score += item.popularityScore * 0.02;

    return score;
  }

  Future<void> _applyExternalRatingScores({
    required Map<String, _ScoredSearchItem> scored,
    required ParsedQuery parsed,
    required Map<String, double> externalRatings,
    required int resultLimit,
  }) async {
    final sourceKey = parsed.ratingSourceKey;
    if (sourceKey == null) return;

    final candidates = scored.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final poolLimit = max(8, min(resultLimit * 2, 28));
    final pool = candidates.take(poolLimit).toList();

    final ratedResults = await Future.wait(
      pool.map((candidate) async {
        final item = candidate.item;
        final tmdbId = item.providerTmdbId?.trim();
        if (tmdbId == null || tmdbId.isEmpty) return null;

        final mediaType = item.itemType ?? 'Movie';
        final ratings = await _mdbListRepository.getRatings(
          tmdbId: tmdbId,
          mediaType: mediaType,
        );
        if (ratings == null || ratings.isEmpty) return null;

        final rating = _resolveSourceRating(ratings, sourceKey);
        if (rating == null || rating <= 0) return null;

        final normalized = _normalizeRatingValue(rating);
        return (
          key: '${item.serverKey}:${item.itemId}',
          item: item,
          score: candidate.score,
          rating: rating,
          normalized: normalized,
        );
      }),
    );

    for (final rated in ratedResults) {
      if (rated == null) continue;

      externalRatings[rated.key] = rated.rating;
      scored[rated.key] = _ScoredSearchItem(
        rated.item,
        rated.score + (rated.normalized * 0.8),
      );
    }
  }

  Future<void> _applySemanticScores({
    required Map<String, _ScoredSearchItem> scored,
    required String serverKey,
    required String query,
    required int resultLimit,
  }) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final queryEmbedding = await _embeddingService.embedText(normalized);
    if (queryEmbedding == null) return;

    final candidateIds = scored.values
        .map((value) => value.item.itemId)
        .toSet();
    final embeddingRows = await _db.getEmbeddingCandidates(
      serverKey: serverKey,
      itemIds: candidateIds.isEmpty ? null : candidateIds,
      limit: candidateIds.isEmpty ? resultLimit * 10 : candidateIds.length,
    );

    if (embeddingRows.isEmpty) return;

    for (final row in embeddingRows) {
      final itemEmbedding = _embeddingService.fromBytes(row.embedding);
      final cosine = _embeddingService.cosineSimilarity(
        queryEmbedding,
        itemEmbedding,
      );

      final semanticScore = ((cosine + 1.0) / 2.0).clamp(0.0, 1.0).toDouble();
      if (semanticScore <= 0) continue;

      final key = '${row.item.serverKey}:${row.item.itemId}';
      final current = scored[key];
      if (current == null) {
        scored[key] = _ScoredSearchItem(row.item, 0.2 + (semanticScore * 0.45));
      } else {
        scored[key] = _ScoredSearchItem(
          current.item,
          current.score + (semanticScore * 0.35),
        );
      }
    }
  }

  double _normalizeRatingValue(double rawValue) {
    if (rawValue <= 0) return 0;
    if (rawValue > 10) {
      return (rawValue / 100).clamp(0.0, 1.0);
    }
    return (rawValue / 10).clamp(0.0, 1.0);
  }

  double? _resolveSourceRating(Map<String, double> ratings, String sourceKey) {
    if (ratings.containsKey(sourceKey)) return ratings[sourceKey];

    final aliases = <String, List<String>>{
      'imdb': ['imdb'],
      'tmdb': ['tmdb'],
      'metacritic': ['metacritic', 'metacriticscore'],
      'metacriticuser': ['metacriticuser', 'metacritic_user'],
      'tomatoes': ['tomatoes', 'rottentomatoes', 'rtcritics'],
      'rtaudience': ['rtaudience', 'rottentomatoesaudience'],
      'trakt': ['trakt'],
      'letterboxd': ['letterboxd'],
      'myanimelist': ['myanimelist', 'mal'],
      'anilist': ['anilist'],
    };

    final sourceAliases = aliases[sourceKey] ?? const [];
    for (final alias in sourceAliases) {
      if (ratings.containsKey(alias)) {
        return ratings[alias];
      }
    }

    return null;
  }

  String _toFtsQuery(String query) {
    final normalized = query.toLowerCase();
    final tokens = RegExp(r'[a-z0-9]+')
        .allMatches(normalized)
        .map((match) => match.group(0)!)
        .where((token) => token.length >= 2)
        .toList();

    if (tokens.isEmpty) return '';

    return tokens.map((token) => '$token*').join(' AND ');
  }

  int _normalizeLimit(int value) {
    if (value < 1) return 1;
    if (value > 120) return 120;
    return value;
  }
}

class _ScoredSearchItem {
  final CatalogIndexItem item;
  final double score;

  const _ScoredSearchItem(this.item, this.score);
}
