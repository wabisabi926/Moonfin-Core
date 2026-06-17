import 'package:drift/drift.dart';

part 'search_database.g.dart';

class CatalogIndexEntry {
  final String itemId;
  final String serverKey;
  final String itemServerId;
  final String title;
  final String? itemType;
  final String? overview;
  final int? productionYear;
  final double? communityRating;
  final String? officialRating;
  final int? runTimeTicks;
  final String genresText;
  final String actorsText;
  final String directorsText;
  final String? tmdbId;
  final String? imdbId;
  final String rawDataJson;
  final double popularityScore;

  const CatalogIndexEntry({
    required this.itemId,
    required this.serverKey,
    required this.itemServerId,
    required this.title,
    required this.itemType,
    required this.overview,
    required this.productionYear,
    required this.communityRating,
    required this.officialRating,
    required this.runTimeTicks,
    required this.genresText,
    required this.actorsText,
    required this.directorsText,
    required this.tmdbId,
    required this.imdbId,
    required this.rawDataJson,
    required this.popularityScore,
  });
}

class CatalogSimilarEntry {
  final String mediaId;
  final String serverKey;
  final String similarId;
  final String similarServerKey;
  final double score;

  const CatalogSimilarEntry({
    required this.mediaId,
    required this.serverKey,
    required this.similarId,
    required this.similarServerKey,
    required this.score,
  });
}

class CatalogSearchHit {
  final CatalogIndexItem item;
  final double score;

  const CatalogSearchHit({required this.item, required this.score});
}

class CatalogEmbeddingEntry {
  final String itemId;
  final String serverKey;
  final Uint8List embedding;

  const CatalogEmbeddingEntry({
    required this.itemId,
    required this.serverKey,
    required this.embedding,
  });
}

class CatalogEmbeddingCandidate {
  final CatalogIndexItem item;
  final Uint8List embedding;

  const CatalogEmbeddingCandidate({
    required this.item,
    required this.embedding,
  });
}

class CatalogIndexItems extends Table {
  TextColumn get itemId => text()();
  TextColumn get serverKey => text()();
  TextColumn get itemServerId => text().withDefault(const Constant(''))();
  TextColumn get title => text()();
  TextColumn get itemType => text().nullable()();
  TextColumn get overview => text().nullable()();
  IntColumn get productionYear => integer().nullable()();
  RealColumn get communityRating => real().nullable()();
  TextColumn get officialRating => text().nullable()();
  IntColumn get runTimeTicks => integer().nullable()();
  TextColumn get genresText => text().withDefault(const Constant(''))();
  TextColumn get actorsText => text().withDefault(const Constant(''))();
  TextColumn get directorsText => text().withDefault(const Constant(''))();
  TextColumn get providerTmdbId => text().nullable()();
  TextColumn get providerImdbId => text().nullable()();
  TextColumn get rawDataJson => text()();
  RealColumn get popularityScore => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {itemId, serverKey};
}

class CatalogSimilarItems extends Table {
  TextColumn get mediaId => text()();
  TextColumn get serverKey => text()();
  TextColumn get similarId => text()();
  TextColumn get similarServerKey => text()();
  RealColumn get score => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    serverKey,
    similarId,
    similarServerKey,
  };
}

class CatalogSyncStates extends Table {
  TextColumn get serverKey => text()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  DateTimeColumn get lastFullSyncAt => dateTime().nullable()();
  IntColumn get totalItems => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {serverKey};
}

class CatalogEmbeddings extends Table {
  TextColumn get itemId => text()();
  TextColumn get serverKey => text()();
  BlobColumn get embedding => blob()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {itemId, serverKey};
}

@DriftDatabase(
  tables: [
    CatalogIndexItems,
    CatalogSimilarItems,
    CatalogSyncStates,
    CatalogEmbeddings,
  ],
)
class SearchDatabase extends _$SearchDatabase {
  SearchDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createSearchObjects();
    },
    onUpgrade: (m, from, to) async {
      await _createSearchObjects();
    },
  );

  Future<void> _createSearchObjects() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS media_fts USING fts5(
        item_id UNINDEXED,
        server_key UNINDEXED,
        title,
        overview,
        genres_text,
        actors_text,
        directors_text
      )
    ''');

    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_catalog_index_items_server_key ON catalog_index_items (server_key)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_catalog_index_items_item_type ON catalog_index_items (item_type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_catalog_similar_items_media ON catalog_similar_items (media_id, server_key)',
    );
  }

  Future<bool> hasCatalogEntries(String serverKey) async {
    final countExpr = catalogIndexItems.itemId.count();
    final query = selectOnly(catalogIndexItems)
      ..addColumns([countExpr])
      ..where(catalogIndexItems.serverKey.equals(serverKey));
    final row = await query.getSingle();
    return (row.read(countExpr) ?? 0) > 0;
  }

  Future<int> countCatalogEntries(String serverKey) async {
    final countExpr = catalogIndexItems.itemId.count();
    final query = selectOnly(catalogIndexItems)
      ..addColumns([countExpr])
      ..where(catalogIndexItems.serverKey.equals(serverKey));
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  Future<CatalogSyncState?> getSyncState(String serverKey) {
    return (select(
      catalogSyncStates,
    )..where((tbl) => tbl.serverKey.equals(serverKey))).getSingleOrNull();
  }

  Future<void> upsertSyncState({
    required String serverKey,
    required DateTime lastSyncAt,
    DateTime? lastFullSyncAt,
    required int totalItems,
  }) {
    return into(catalogSyncStates).insertOnConflictUpdate(
      CatalogSyncStatesCompanion.insert(
        serverKey: serverKey,
        lastSyncAt: Value(lastSyncAt),
        lastFullSyncAt: Value(lastFullSyncAt),
        totalItems: Value(totalItems),
      ),
    );
  }

  Future<void> upsertCatalogEntries(List<CatalogIndexEntry> entries) async {
    if (entries.isEmpty) return;

    await transaction(() async {
      await batch((batch) {
        for (final entry in entries) {
          batch.insert(
            catalogIndexItems,
            CatalogIndexItemsCompanion.insert(
              itemId: entry.itemId,
              serverKey: entry.serverKey,
              itemServerId: Value(entry.itemServerId),
              title: entry.title,
              itemType: Value(entry.itemType),
              overview: Value(entry.overview),
              productionYear: Value(entry.productionYear),
              communityRating: Value(entry.communityRating),
              officialRating: Value(entry.officialRating),
              runTimeTicks: Value(entry.runTimeTicks),
              genresText: Value(entry.genresText),
              actorsText: Value(entry.actorsText),
              directorsText: Value(entry.directorsText),
              providerTmdbId: Value(entry.tmdbId),
              providerImdbId: Value(entry.imdbId),
              rawDataJson: entry.rawDataJson,
              popularityScore: Value(entry.popularityScore),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      for (final entry in entries) {
        await customStatement(
          'DELETE FROM media_fts WHERE item_id = ? AND server_key = ?',
          [entry.itemId, entry.serverKey],
        );
        await customStatement(
          'INSERT INTO media_fts (item_id, server_key, title, overview, genres_text, actors_text, directors_text) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            entry.itemId,
            entry.serverKey,
            entry.title,
            entry.overview ?? '',
            entry.genresText,
            entry.actorsText,
            entry.directorsText,
          ],
        );
      }
    });
  }

  Future<void> replaceSimilarItems({
    required String mediaId,
    required String serverKey,
    required List<CatalogSimilarEntry> similarEntries,
  }) async {
    await transaction(() async {
      await (delete(catalogSimilarItems)..where(
            (tbl) =>
                tbl.mediaId.equals(mediaId) & tbl.serverKey.equals(serverKey),
          ))
          .go();

      if (similarEntries.isEmpty) return;

      await batch((batch) {
        for (final entry in similarEntries) {
          batch.insert(
            catalogSimilarItems,
            CatalogSimilarItemsCompanion.insert(
              mediaId: entry.mediaId,
              serverKey: entry.serverKey,
              similarId: entry.similarId,
              similarServerKey: entry.similarServerKey,
              score: Value(entry.score),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    });
  }

  Future<void> clearServerCatalog(String serverKey) async {
    await transaction(() async {
      await (delete(
        catalogIndexItems,
      )..where((tbl) => tbl.serverKey.equals(serverKey))).go();
      await (delete(
        catalogSimilarItems,
      )..where((tbl) => tbl.serverKey.equals(serverKey))).go();
      await (delete(
        catalogEmbeddings,
      )..where((tbl) => tbl.serverKey.equals(serverKey))).go();
      await customStatement('DELETE FROM media_fts WHERE server_key = ?', [
        serverKey,
      ]);
    });
  }

  Future<void> removeCatalogEntriesNotIn(
    String serverKey,
    Set<String> idsToKeep,
  ) async {
    final rows = await customSelect(
      'SELECT item_id FROM catalog_index_items WHERE server_key = ?',
      variables: [Variable.withString(serverKey)],
    ).get();

    final staleIds = rows
        .map((row) => row.read<String>('item_id'))
        .where((itemId) => !idsToKeep.contains(itemId))
        .toList();

    if (staleIds.isEmpty) return;

    for (final chunk in _chunks(staleIds, 300)) {
      final placeholders = List.filled(chunk.length, '?').join(', ');
      final chunkArgs = [serverKey, ...chunk];

      await customStatement(
        'DELETE FROM catalog_index_items WHERE server_key = ? AND item_id IN ($placeholders)',
        chunkArgs,
      );
      await customStatement(
        'DELETE FROM media_fts WHERE server_key = ? AND item_id IN ($placeholders)',
        chunkArgs,
      );
      await customStatement(
        'DELETE FROM catalog_similar_items WHERE server_key = ? AND media_id IN ($placeholders)',
        chunkArgs,
      );
      await customStatement(
        'DELETE FROM catalog_similar_items WHERE similar_server_key = ? AND similar_id IN ($placeholders)',
        chunkArgs,
      );
      await customStatement(
        'DELETE FROM catalog_embeddings WHERE server_key = ? AND item_id IN ($placeholders)',
        chunkArgs,
      );
    }
  }

  Future<List<CatalogIndexItem>> searchMetadata({
    required String serverKey,
    List<String> itemTypes = const [],
    List<String> genres = const [],
    List<String> actors = const [],
    List<String> directors = const [],
    int? yearStart,
    int? yearEnd,
    bool sortByRatingDesc = false,
    int limit = 48,
  }) async {
    final sql = StringBuffer(
      'SELECT c.* FROM catalog_index_items c WHERE c.server_key = ?',
    );
    final vars = <Variable<Object>>[Variable.withString(serverKey)];

    if (itemTypes.isNotEmpty) {
      final placeholders = List.filled(itemTypes.length, '?').join(', ');
      sql.write(' AND c.item_type IN ($placeholders)');
      vars.addAll(itemTypes.map(Variable.withString));
    }

    if (yearStart != null) {
      sql.write(' AND c.production_year >= ?');
      vars.add(Variable.withInt(yearStart));
    }

    if (yearEnd != null) {
      sql.write(' AND c.production_year <= ?');
      vars.add(Variable.withInt(yearEnd));
    }

    for (final genre in genres) {
      sql.write(' AND c.genres_text LIKE ?');
      vars.add(Variable.withString('%${genre.toLowerCase()}%'));
    }

    for (final actor in actors) {
      sql.write(' AND c.actors_text LIKE ?');
      vars.add(Variable.withString('%${actor.toLowerCase()}%'));
    }

    for (final director in directors) {
      sql.write(' AND c.directors_text LIKE ?');
      vars.add(Variable.withString('%${director.toLowerCase()}%'));
    }

    if (sortByRatingDesc) {
      sql.write(
        ' ORDER BY COALESCE(c.community_rating, 0.0) DESC, c.title COLLATE NOCASE ASC',
      );
    } else {
      sql.write(' ORDER BY c.title COLLATE NOCASE ASC');
    }

    sql.write(' LIMIT ?');
    vars.add(Variable.withInt(limit));

    final rows = await customSelect(sql.toString(), variables: vars).get();
    return rows.map((row) => catalogIndexItems.map(row.data)).toList();
  }

  Future<List<CatalogSearchHit>> searchFts({
    required String serverKey,
    required String ftsQuery,
    int limit = 48,
  }) async {
    if (ftsQuery.trim().isEmpty) return const [];

    final rows = await customSelect(
      '''
      SELECT c.*, bm25(media_fts, 2.5, 1.0, 0.8, 0.5, 0.5) AS rank
      FROM media_fts
      JOIN catalog_index_items c
        ON c.item_id = media_fts.item_id
       AND c.server_key = media_fts.server_key
      WHERE media_fts.server_key = ?
        AND media_fts MATCH ?
      ORDER BY rank ASC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(serverKey),
        Variable.withString(ftsQuery),
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) {
      final rank = row.read<num?>('rank')?.toDouble() ?? 9999.0;
      final normalized = 1.0 / (1.0 + rank.abs());
      return CatalogSearchHit(
        item: catalogIndexItems.map(row.data),
        score: normalized,
      );
    }).toList();
  }

  Future<List<CatalogIndexItem>> getSimilarItems({
    required String serverKey,
    required String mediaId,
    int limit = 24,
  }) async {
    final rows = await customSelect(
      '''
      SELECT c.*
      FROM catalog_similar_items s
      JOIN catalog_index_items c
        ON c.item_id = s.similar_id
       AND c.server_key = s.similar_server_key
      WHERE s.server_key = ?
        AND s.media_id = ?
      ORDER BY s.score DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(serverKey),
        Variable.withString(mediaId),
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => catalogIndexItems.map(row.data)).toList();
  }

  Future<void> upsertEmbeddings(List<CatalogEmbeddingEntry> entries) async {
    if (entries.isEmpty) return;

    await batch((batch) {
      for (final entry in entries) {
        batch.insert(
          catalogEmbeddings,
          CatalogEmbeddingsCompanion.insert(
            itemId: entry.itemId,
            serverKey: entry.serverKey,
            embedding: entry.embedding,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<CatalogEmbeddingCandidate>> getEmbeddingCandidates({
    required String serverKey,
    Set<String>? itemIds,
    int limit = 1200,
  }) async {
    final hasItemFilter = itemIds != null && itemIds.isNotEmpty;

    final sql = StringBuffer('''
      SELECT c.*, e.embedding
      FROM catalog_embeddings e
      JOIN catalog_index_items c
        ON c.item_id = e.item_id
       AND c.server_key = e.server_key
      WHERE e.server_key = ?
    ''');

    final vars = <Variable<Object>>[Variable.withString(serverKey)];

    if (hasItemFilter) {
      final ids = itemIds.toList(growable: false);
      final placeholders = List.filled(ids.length, '?').join(', ');
      sql.write(' AND e.item_id IN ($placeholders)');
      vars.addAll(ids.map(Variable.withString));
    }

    sql.write(' ORDER BY c.updated_at DESC LIMIT ?');
    vars.add(Variable.withInt(limit));

    final rows = await customSelect(sql.toString(), variables: vars).get();
    return rows
        .map(
          (row) => CatalogEmbeddingCandidate(
            item: catalogIndexItems.map(row.data),
            embedding: row.read<Uint8List>('embedding'),
          ),
        )
        .toList();
  }

  Iterable<List<T>> _chunks<T>(List<T> values, int chunkSize) sync* {
    if (values.isEmpty) return;
    for (var i = 0; i < values.length; i += chunkSize) {
      final end = (i + chunkSize < values.length)
          ? i + chunkSize
          : values.length;
      yield values.sublist(i, end);
    }
  }
}
