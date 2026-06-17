// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_database.dart';

// ignore_for_file: type=lint
class $CatalogIndexItemsTable extends CatalogIndexItems
    with TableInfo<$CatalogIndexItemsTable, CatalogIndexItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogIndexItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverKeyMeta = const VerificationMeta(
    'serverKey',
  );
  @override
  late final GeneratedColumn<String> serverKey = GeneratedColumn<String>(
    'server_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemServerIdMeta = const VerificationMeta(
    'itemServerId',
  );
  @override
  late final GeneratedColumn<String> itemServerId = GeneratedColumn<String>(
    'item_server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productionYearMeta = const VerificationMeta(
    'productionYear',
  );
  @override
  late final GeneratedColumn<int> productionYear = GeneratedColumn<int>(
    'production_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _communityRatingMeta = const VerificationMeta(
    'communityRating',
  );
  @override
  late final GeneratedColumn<double> communityRating = GeneratedColumn<double>(
    'community_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _officialRatingMeta = const VerificationMeta(
    'officialRating',
  );
  @override
  late final GeneratedColumn<String> officialRating = GeneratedColumn<String>(
    'official_rating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _runTimeTicksMeta = const VerificationMeta(
    'runTimeTicks',
  );
  @override
  late final GeneratedColumn<int> runTimeTicks = GeneratedColumn<int>(
    'run_time_ticks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genresTextMeta = const VerificationMeta(
    'genresText',
  );
  @override
  late final GeneratedColumn<String> genresText = GeneratedColumn<String>(
    'genres_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _actorsTextMeta = const VerificationMeta(
    'actorsText',
  );
  @override
  late final GeneratedColumn<String> actorsText = GeneratedColumn<String>(
    'actors_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _directorsTextMeta = const VerificationMeta(
    'directorsText',
  );
  @override
  late final GeneratedColumn<String> directorsText = GeneratedColumn<String>(
    'directors_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _providerTmdbIdMeta = const VerificationMeta(
    'providerTmdbId',
  );
  @override
  late final GeneratedColumn<String> providerTmdbId = GeneratedColumn<String>(
    'provider_tmdb_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerImdbIdMeta = const VerificationMeta(
    'providerImdbId',
  );
  @override
  late final GeneratedColumn<String> providerImdbId = GeneratedColumn<String>(
    'provider_imdb_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawDataJsonMeta = const VerificationMeta(
    'rawDataJson',
  );
  @override
  late final GeneratedColumn<String> rawDataJson = GeneratedColumn<String>(
    'raw_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _popularityScoreMeta = const VerificationMeta(
    'popularityScore',
  );
  @override
  late final GeneratedColumn<double> popularityScore = GeneratedColumn<double>(
    'popularity_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    serverKey,
    itemServerId,
    title,
    itemType,
    overview,
    productionYear,
    communityRating,
    officialRating,
    runTimeTicks,
    genresText,
    actorsText,
    directorsText,
    providerTmdbId,
    providerImdbId,
    rawDataJson,
    popularityScore,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_index_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogIndexItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('server_key')) {
      context.handle(
        _serverKeyMeta,
        serverKey.isAcceptableOrUnknown(data['server_key']!, _serverKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_serverKeyMeta);
    }
    if (data.containsKey('item_server_id')) {
      context.handle(
        _itemServerIdMeta,
        itemServerId.isAcceptableOrUnknown(
          data['item_server_id']!,
          _itemServerIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('production_year')) {
      context.handle(
        _productionYearMeta,
        productionYear.isAcceptableOrUnknown(
          data['production_year']!,
          _productionYearMeta,
        ),
      );
    }
    if (data.containsKey('community_rating')) {
      context.handle(
        _communityRatingMeta,
        communityRating.isAcceptableOrUnknown(
          data['community_rating']!,
          _communityRatingMeta,
        ),
      );
    }
    if (data.containsKey('official_rating')) {
      context.handle(
        _officialRatingMeta,
        officialRating.isAcceptableOrUnknown(
          data['official_rating']!,
          _officialRatingMeta,
        ),
      );
    }
    if (data.containsKey('run_time_ticks')) {
      context.handle(
        _runTimeTicksMeta,
        runTimeTicks.isAcceptableOrUnknown(
          data['run_time_ticks']!,
          _runTimeTicksMeta,
        ),
      );
    }
    if (data.containsKey('genres_text')) {
      context.handle(
        _genresTextMeta,
        genresText.isAcceptableOrUnknown(data['genres_text']!, _genresTextMeta),
      );
    }
    if (data.containsKey('actors_text')) {
      context.handle(
        _actorsTextMeta,
        actorsText.isAcceptableOrUnknown(data['actors_text']!, _actorsTextMeta),
      );
    }
    if (data.containsKey('directors_text')) {
      context.handle(
        _directorsTextMeta,
        directorsText.isAcceptableOrUnknown(
          data['directors_text']!,
          _directorsTextMeta,
        ),
      );
    }
    if (data.containsKey('provider_tmdb_id')) {
      context.handle(
        _providerTmdbIdMeta,
        providerTmdbId.isAcceptableOrUnknown(
          data['provider_tmdb_id']!,
          _providerTmdbIdMeta,
        ),
      );
    }
    if (data.containsKey('provider_imdb_id')) {
      context.handle(
        _providerImdbIdMeta,
        providerImdbId.isAcceptableOrUnknown(
          data['provider_imdb_id']!,
          _providerImdbIdMeta,
        ),
      );
    }
    if (data.containsKey('raw_data_json')) {
      context.handle(
        _rawDataJsonMeta,
        rawDataJson.isAcceptableOrUnknown(
          data['raw_data_json']!,
          _rawDataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawDataJsonMeta);
    }
    if (data.containsKey('popularity_score')) {
      context.handle(
        _popularityScoreMeta,
        popularityScore.isAcceptableOrUnknown(
          data['popularity_score']!,
          _popularityScoreMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, serverKey};
  @override
  CatalogIndexItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogIndexItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      serverKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_key'],
      )!,
      itemServerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_server_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      productionYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}production_year'],
      ),
      communityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}community_rating'],
      ),
      officialRating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official_rating'],
      ),
      runTimeTicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}run_time_ticks'],
      ),
      genresText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres_text'],
      )!,
      actorsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actors_text'],
      )!,
      directorsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}directors_text'],
      )!,
      providerTmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_tmdb_id'],
      ),
      providerImdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_imdb_id'],
      ),
      rawDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_data_json'],
      )!,
      popularityScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}popularity_score'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogIndexItemsTable createAlias(String alias) {
    return $CatalogIndexItemsTable(attachedDatabase, alias);
  }
}

class CatalogIndexItem extends DataClass
    implements Insertable<CatalogIndexItem> {
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
  final String? providerTmdbId;
  final String? providerImdbId;
  final String rawDataJson;
  final double popularityScore;
  final DateTime updatedAt;
  const CatalogIndexItem({
    required this.itemId,
    required this.serverKey,
    required this.itemServerId,
    required this.title,
    this.itemType,
    this.overview,
    this.productionYear,
    this.communityRating,
    this.officialRating,
    this.runTimeTicks,
    required this.genresText,
    required this.actorsText,
    required this.directorsText,
    this.providerTmdbId,
    this.providerImdbId,
    required this.rawDataJson,
    required this.popularityScore,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['server_key'] = Variable<String>(serverKey);
    map['item_server_id'] = Variable<String>(itemServerId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || itemType != null) {
      map['item_type'] = Variable<String>(itemType);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || productionYear != null) {
      map['production_year'] = Variable<int>(productionYear);
    }
    if (!nullToAbsent || communityRating != null) {
      map['community_rating'] = Variable<double>(communityRating);
    }
    if (!nullToAbsent || officialRating != null) {
      map['official_rating'] = Variable<String>(officialRating);
    }
    if (!nullToAbsent || runTimeTicks != null) {
      map['run_time_ticks'] = Variable<int>(runTimeTicks);
    }
    map['genres_text'] = Variable<String>(genresText);
    map['actors_text'] = Variable<String>(actorsText);
    map['directors_text'] = Variable<String>(directorsText);
    if (!nullToAbsent || providerTmdbId != null) {
      map['provider_tmdb_id'] = Variable<String>(providerTmdbId);
    }
    if (!nullToAbsent || providerImdbId != null) {
      map['provider_imdb_id'] = Variable<String>(providerImdbId);
    }
    map['raw_data_json'] = Variable<String>(rawDataJson);
    map['popularity_score'] = Variable<double>(popularityScore);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogIndexItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogIndexItemsCompanion(
      itemId: Value(itemId),
      serverKey: Value(serverKey),
      itemServerId: Value(itemServerId),
      title: Value(title),
      itemType: itemType == null && nullToAbsent
          ? const Value.absent()
          : Value(itemType),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      productionYear: productionYear == null && nullToAbsent
          ? const Value.absent()
          : Value(productionYear),
      communityRating: communityRating == null && nullToAbsent
          ? const Value.absent()
          : Value(communityRating),
      officialRating: officialRating == null && nullToAbsent
          ? const Value.absent()
          : Value(officialRating),
      runTimeTicks: runTimeTicks == null && nullToAbsent
          ? const Value.absent()
          : Value(runTimeTicks),
      genresText: Value(genresText),
      actorsText: Value(actorsText),
      directorsText: Value(directorsText),
      providerTmdbId: providerTmdbId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerTmdbId),
      providerImdbId: providerImdbId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerImdbId),
      rawDataJson: Value(rawDataJson),
      popularityScore: Value(popularityScore),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogIndexItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogIndexItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      serverKey: serializer.fromJson<String>(json['serverKey']),
      itemServerId: serializer.fromJson<String>(json['itemServerId']),
      title: serializer.fromJson<String>(json['title']),
      itemType: serializer.fromJson<String?>(json['itemType']),
      overview: serializer.fromJson<String?>(json['overview']),
      productionYear: serializer.fromJson<int?>(json['productionYear']),
      communityRating: serializer.fromJson<double?>(json['communityRating']),
      officialRating: serializer.fromJson<String?>(json['officialRating']),
      runTimeTicks: serializer.fromJson<int?>(json['runTimeTicks']),
      genresText: serializer.fromJson<String>(json['genresText']),
      actorsText: serializer.fromJson<String>(json['actorsText']),
      directorsText: serializer.fromJson<String>(json['directorsText']),
      providerTmdbId: serializer.fromJson<String?>(json['providerTmdbId']),
      providerImdbId: serializer.fromJson<String?>(json['providerImdbId']),
      rawDataJson: serializer.fromJson<String>(json['rawDataJson']),
      popularityScore: serializer.fromJson<double>(json['popularityScore']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'serverKey': serializer.toJson<String>(serverKey),
      'itemServerId': serializer.toJson<String>(itemServerId),
      'title': serializer.toJson<String>(title),
      'itemType': serializer.toJson<String?>(itemType),
      'overview': serializer.toJson<String?>(overview),
      'productionYear': serializer.toJson<int?>(productionYear),
      'communityRating': serializer.toJson<double?>(communityRating),
      'officialRating': serializer.toJson<String?>(officialRating),
      'runTimeTicks': serializer.toJson<int?>(runTimeTicks),
      'genresText': serializer.toJson<String>(genresText),
      'actorsText': serializer.toJson<String>(actorsText),
      'directorsText': serializer.toJson<String>(directorsText),
      'providerTmdbId': serializer.toJson<String?>(providerTmdbId),
      'providerImdbId': serializer.toJson<String?>(providerImdbId),
      'rawDataJson': serializer.toJson<String>(rawDataJson),
      'popularityScore': serializer.toJson<double>(popularityScore),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogIndexItem copyWith({
    String? itemId,
    String? serverKey,
    String? itemServerId,
    String? title,
    Value<String?> itemType = const Value.absent(),
    Value<String?> overview = const Value.absent(),
    Value<int?> productionYear = const Value.absent(),
    Value<double?> communityRating = const Value.absent(),
    Value<String?> officialRating = const Value.absent(),
    Value<int?> runTimeTicks = const Value.absent(),
    String? genresText,
    String? actorsText,
    String? directorsText,
    Value<String?> providerTmdbId = const Value.absent(),
    Value<String?> providerImdbId = const Value.absent(),
    String? rawDataJson,
    double? popularityScore,
    DateTime? updatedAt,
  }) => CatalogIndexItem(
    itemId: itemId ?? this.itemId,
    serverKey: serverKey ?? this.serverKey,
    itemServerId: itemServerId ?? this.itemServerId,
    title: title ?? this.title,
    itemType: itemType.present ? itemType.value : this.itemType,
    overview: overview.present ? overview.value : this.overview,
    productionYear: productionYear.present
        ? productionYear.value
        : this.productionYear,
    communityRating: communityRating.present
        ? communityRating.value
        : this.communityRating,
    officialRating: officialRating.present
        ? officialRating.value
        : this.officialRating,
    runTimeTicks: runTimeTicks.present ? runTimeTicks.value : this.runTimeTicks,
    genresText: genresText ?? this.genresText,
    actorsText: actorsText ?? this.actorsText,
    directorsText: directorsText ?? this.directorsText,
    providerTmdbId: providerTmdbId.present
        ? providerTmdbId.value
        : this.providerTmdbId,
    providerImdbId: providerImdbId.present
        ? providerImdbId.value
        : this.providerImdbId,
    rawDataJson: rawDataJson ?? this.rawDataJson,
    popularityScore: popularityScore ?? this.popularityScore,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogIndexItem copyWithCompanion(CatalogIndexItemsCompanion data) {
    return CatalogIndexItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      serverKey: data.serverKey.present ? data.serverKey.value : this.serverKey,
      itemServerId: data.itemServerId.present
          ? data.itemServerId.value
          : this.itemServerId,
      title: data.title.present ? data.title.value : this.title,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      overview: data.overview.present ? data.overview.value : this.overview,
      productionYear: data.productionYear.present
          ? data.productionYear.value
          : this.productionYear,
      communityRating: data.communityRating.present
          ? data.communityRating.value
          : this.communityRating,
      officialRating: data.officialRating.present
          ? data.officialRating.value
          : this.officialRating,
      runTimeTicks: data.runTimeTicks.present
          ? data.runTimeTicks.value
          : this.runTimeTicks,
      genresText: data.genresText.present
          ? data.genresText.value
          : this.genresText,
      actorsText: data.actorsText.present
          ? data.actorsText.value
          : this.actorsText,
      directorsText: data.directorsText.present
          ? data.directorsText.value
          : this.directorsText,
      providerTmdbId: data.providerTmdbId.present
          ? data.providerTmdbId.value
          : this.providerTmdbId,
      providerImdbId: data.providerImdbId.present
          ? data.providerImdbId.value
          : this.providerImdbId,
      rawDataJson: data.rawDataJson.present
          ? data.rawDataJson.value
          : this.rawDataJson,
      popularityScore: data.popularityScore.present
          ? data.popularityScore.value
          : this.popularityScore,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogIndexItem(')
          ..write('itemId: $itemId, ')
          ..write('serverKey: $serverKey, ')
          ..write('itemServerId: $itemServerId, ')
          ..write('title: $title, ')
          ..write('itemType: $itemType, ')
          ..write('overview: $overview, ')
          ..write('productionYear: $productionYear, ')
          ..write('communityRating: $communityRating, ')
          ..write('officialRating: $officialRating, ')
          ..write('runTimeTicks: $runTimeTicks, ')
          ..write('genresText: $genresText, ')
          ..write('actorsText: $actorsText, ')
          ..write('directorsText: $directorsText, ')
          ..write('providerTmdbId: $providerTmdbId, ')
          ..write('providerImdbId: $providerImdbId, ')
          ..write('rawDataJson: $rawDataJson, ')
          ..write('popularityScore: $popularityScore, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    serverKey,
    itemServerId,
    title,
    itemType,
    overview,
    productionYear,
    communityRating,
    officialRating,
    runTimeTicks,
    genresText,
    actorsText,
    directorsText,
    providerTmdbId,
    providerImdbId,
    rawDataJson,
    popularityScore,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogIndexItem &&
          other.itemId == this.itemId &&
          other.serverKey == this.serverKey &&
          other.itemServerId == this.itemServerId &&
          other.title == this.title &&
          other.itemType == this.itemType &&
          other.overview == this.overview &&
          other.productionYear == this.productionYear &&
          other.communityRating == this.communityRating &&
          other.officialRating == this.officialRating &&
          other.runTimeTicks == this.runTimeTicks &&
          other.genresText == this.genresText &&
          other.actorsText == this.actorsText &&
          other.directorsText == this.directorsText &&
          other.providerTmdbId == this.providerTmdbId &&
          other.providerImdbId == this.providerImdbId &&
          other.rawDataJson == this.rawDataJson &&
          other.popularityScore == this.popularityScore &&
          other.updatedAt == this.updatedAt);
}

class CatalogIndexItemsCompanion extends UpdateCompanion<CatalogIndexItem> {
  final Value<String> itemId;
  final Value<String> serverKey;
  final Value<String> itemServerId;
  final Value<String> title;
  final Value<String?> itemType;
  final Value<String?> overview;
  final Value<int?> productionYear;
  final Value<double?> communityRating;
  final Value<String?> officialRating;
  final Value<int?> runTimeTicks;
  final Value<String> genresText;
  final Value<String> actorsText;
  final Value<String> directorsText;
  final Value<String?> providerTmdbId;
  final Value<String?> providerImdbId;
  final Value<String> rawDataJson;
  final Value<double> popularityScore;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogIndexItemsCompanion({
    this.itemId = const Value.absent(),
    this.serverKey = const Value.absent(),
    this.itemServerId = const Value.absent(),
    this.title = const Value.absent(),
    this.itemType = const Value.absent(),
    this.overview = const Value.absent(),
    this.productionYear = const Value.absent(),
    this.communityRating = const Value.absent(),
    this.officialRating = const Value.absent(),
    this.runTimeTicks = const Value.absent(),
    this.genresText = const Value.absent(),
    this.actorsText = const Value.absent(),
    this.directorsText = const Value.absent(),
    this.providerTmdbId = const Value.absent(),
    this.providerImdbId = const Value.absent(),
    this.rawDataJson = const Value.absent(),
    this.popularityScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogIndexItemsCompanion.insert({
    required String itemId,
    required String serverKey,
    this.itemServerId = const Value.absent(),
    required String title,
    this.itemType = const Value.absent(),
    this.overview = const Value.absent(),
    this.productionYear = const Value.absent(),
    this.communityRating = const Value.absent(),
    this.officialRating = const Value.absent(),
    this.runTimeTicks = const Value.absent(),
    this.genresText = const Value.absent(),
    this.actorsText = const Value.absent(),
    this.directorsText = const Value.absent(),
    this.providerTmdbId = const Value.absent(),
    this.providerImdbId = const Value.absent(),
    required String rawDataJson,
    this.popularityScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       serverKey = Value(serverKey),
       title = Value(title),
       rawDataJson = Value(rawDataJson);
  static Insertable<CatalogIndexItem> custom({
    Expression<String>? itemId,
    Expression<String>? serverKey,
    Expression<String>? itemServerId,
    Expression<String>? title,
    Expression<String>? itemType,
    Expression<String>? overview,
    Expression<int>? productionYear,
    Expression<double>? communityRating,
    Expression<String>? officialRating,
    Expression<int>? runTimeTicks,
    Expression<String>? genresText,
    Expression<String>? actorsText,
    Expression<String>? directorsText,
    Expression<String>? providerTmdbId,
    Expression<String>? providerImdbId,
    Expression<String>? rawDataJson,
    Expression<double>? popularityScore,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (serverKey != null) 'server_key': serverKey,
      if (itemServerId != null) 'item_server_id': itemServerId,
      if (title != null) 'title': title,
      if (itemType != null) 'item_type': itemType,
      if (overview != null) 'overview': overview,
      if (productionYear != null) 'production_year': productionYear,
      if (communityRating != null) 'community_rating': communityRating,
      if (officialRating != null) 'official_rating': officialRating,
      if (runTimeTicks != null) 'run_time_ticks': runTimeTicks,
      if (genresText != null) 'genres_text': genresText,
      if (actorsText != null) 'actors_text': actorsText,
      if (directorsText != null) 'directors_text': directorsText,
      if (providerTmdbId != null) 'provider_tmdb_id': providerTmdbId,
      if (providerImdbId != null) 'provider_imdb_id': providerImdbId,
      if (rawDataJson != null) 'raw_data_json': rawDataJson,
      if (popularityScore != null) 'popularity_score': popularityScore,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogIndexItemsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? serverKey,
    Value<String>? itemServerId,
    Value<String>? title,
    Value<String?>? itemType,
    Value<String?>? overview,
    Value<int?>? productionYear,
    Value<double?>? communityRating,
    Value<String?>? officialRating,
    Value<int?>? runTimeTicks,
    Value<String>? genresText,
    Value<String>? actorsText,
    Value<String>? directorsText,
    Value<String?>? providerTmdbId,
    Value<String?>? providerImdbId,
    Value<String>? rawDataJson,
    Value<double>? popularityScore,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogIndexItemsCompanion(
      itemId: itemId ?? this.itemId,
      serverKey: serverKey ?? this.serverKey,
      itemServerId: itemServerId ?? this.itemServerId,
      title: title ?? this.title,
      itemType: itemType ?? this.itemType,
      overview: overview ?? this.overview,
      productionYear: productionYear ?? this.productionYear,
      communityRating: communityRating ?? this.communityRating,
      officialRating: officialRating ?? this.officialRating,
      runTimeTicks: runTimeTicks ?? this.runTimeTicks,
      genresText: genresText ?? this.genresText,
      actorsText: actorsText ?? this.actorsText,
      directorsText: directorsText ?? this.directorsText,
      providerTmdbId: providerTmdbId ?? this.providerTmdbId,
      providerImdbId: providerImdbId ?? this.providerImdbId,
      rawDataJson: rawDataJson ?? this.rawDataJson,
      popularityScore: popularityScore ?? this.popularityScore,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (serverKey.present) {
      map['server_key'] = Variable<String>(serverKey.value);
    }
    if (itemServerId.present) {
      map['item_server_id'] = Variable<String>(itemServerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (productionYear.present) {
      map['production_year'] = Variable<int>(productionYear.value);
    }
    if (communityRating.present) {
      map['community_rating'] = Variable<double>(communityRating.value);
    }
    if (officialRating.present) {
      map['official_rating'] = Variable<String>(officialRating.value);
    }
    if (runTimeTicks.present) {
      map['run_time_ticks'] = Variable<int>(runTimeTicks.value);
    }
    if (genresText.present) {
      map['genres_text'] = Variable<String>(genresText.value);
    }
    if (actorsText.present) {
      map['actors_text'] = Variable<String>(actorsText.value);
    }
    if (directorsText.present) {
      map['directors_text'] = Variable<String>(directorsText.value);
    }
    if (providerTmdbId.present) {
      map['provider_tmdb_id'] = Variable<String>(providerTmdbId.value);
    }
    if (providerImdbId.present) {
      map['provider_imdb_id'] = Variable<String>(providerImdbId.value);
    }
    if (rawDataJson.present) {
      map['raw_data_json'] = Variable<String>(rawDataJson.value);
    }
    if (popularityScore.present) {
      map['popularity_score'] = Variable<double>(popularityScore.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogIndexItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('serverKey: $serverKey, ')
          ..write('itemServerId: $itemServerId, ')
          ..write('title: $title, ')
          ..write('itemType: $itemType, ')
          ..write('overview: $overview, ')
          ..write('productionYear: $productionYear, ')
          ..write('communityRating: $communityRating, ')
          ..write('officialRating: $officialRating, ')
          ..write('runTimeTicks: $runTimeTicks, ')
          ..write('genresText: $genresText, ')
          ..write('actorsText: $actorsText, ')
          ..write('directorsText: $directorsText, ')
          ..write('providerTmdbId: $providerTmdbId, ')
          ..write('providerImdbId: $providerImdbId, ')
          ..write('rawDataJson: $rawDataJson, ')
          ..write('popularityScore: $popularityScore, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogSimilarItemsTable extends CatalogSimilarItems
    with TableInfo<$CatalogSimilarItemsTable, CatalogSimilarItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogSimilarItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverKeyMeta = const VerificationMeta(
    'serverKey',
  );
  @override
  late final GeneratedColumn<String> serverKey = GeneratedColumn<String>(
    'server_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _similarIdMeta = const VerificationMeta(
    'similarId',
  );
  @override
  late final GeneratedColumn<String> similarId = GeneratedColumn<String>(
    'similar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _similarServerKeyMeta = const VerificationMeta(
    'similarServerKey',
  );
  @override
  late final GeneratedColumn<String> similarServerKey = GeneratedColumn<String>(
    'similar_server_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    mediaId,
    serverKey,
    similarId,
    similarServerKey,
    score,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_similar_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogSimilarItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('server_key')) {
      context.handle(
        _serverKeyMeta,
        serverKey.isAcceptableOrUnknown(data['server_key']!, _serverKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_serverKeyMeta);
    }
    if (data.containsKey('similar_id')) {
      context.handle(
        _similarIdMeta,
        similarId.isAcceptableOrUnknown(data['similar_id']!, _similarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_similarIdMeta);
    }
    if (data.containsKey('similar_server_key')) {
      context.handle(
        _similarServerKeyMeta,
        similarServerKey.isAcceptableOrUnknown(
          data['similar_server_key']!,
          _similarServerKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_similarServerKeyMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    mediaId,
    serverKey,
    similarId,
    similarServerKey,
  };
  @override
  CatalogSimilarItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogSimilarItem(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      serverKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_key'],
      )!,
      similarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}similar_id'],
      )!,
      similarServerKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}similar_server_key'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
    );
  }

  @override
  $CatalogSimilarItemsTable createAlias(String alias) {
    return $CatalogSimilarItemsTable(attachedDatabase, alias);
  }
}

class CatalogSimilarItem extends DataClass
    implements Insertable<CatalogSimilarItem> {
  final String mediaId;
  final String serverKey;
  final String similarId;
  final String similarServerKey;
  final double score;
  const CatalogSimilarItem({
    required this.mediaId,
    required this.serverKey,
    required this.similarId,
    required this.similarServerKey,
    required this.score,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<String>(mediaId);
    map['server_key'] = Variable<String>(serverKey);
    map['similar_id'] = Variable<String>(similarId);
    map['similar_server_key'] = Variable<String>(similarServerKey);
    map['score'] = Variable<double>(score);
    return map;
  }

  CatalogSimilarItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogSimilarItemsCompanion(
      mediaId: Value(mediaId),
      serverKey: Value(serverKey),
      similarId: Value(similarId),
      similarServerKey: Value(similarServerKey),
      score: Value(score),
    );
  }

  factory CatalogSimilarItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogSimilarItem(
      mediaId: serializer.fromJson<String>(json['mediaId']),
      serverKey: serializer.fromJson<String>(json['serverKey']),
      similarId: serializer.fromJson<String>(json['similarId']),
      similarServerKey: serializer.fromJson<String>(json['similarServerKey']),
      score: serializer.fromJson<double>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<String>(mediaId),
      'serverKey': serializer.toJson<String>(serverKey),
      'similarId': serializer.toJson<String>(similarId),
      'similarServerKey': serializer.toJson<String>(similarServerKey),
      'score': serializer.toJson<double>(score),
    };
  }

  CatalogSimilarItem copyWith({
    String? mediaId,
    String? serverKey,
    String? similarId,
    String? similarServerKey,
    double? score,
  }) => CatalogSimilarItem(
    mediaId: mediaId ?? this.mediaId,
    serverKey: serverKey ?? this.serverKey,
    similarId: similarId ?? this.similarId,
    similarServerKey: similarServerKey ?? this.similarServerKey,
    score: score ?? this.score,
  );
  CatalogSimilarItem copyWithCompanion(CatalogSimilarItemsCompanion data) {
    return CatalogSimilarItem(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      serverKey: data.serverKey.present ? data.serverKey.value : this.serverKey,
      similarId: data.similarId.present ? data.similarId.value : this.similarId,
      similarServerKey: data.similarServerKey.present
          ? data.similarServerKey.value
          : this.similarServerKey,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSimilarItem(')
          ..write('mediaId: $mediaId, ')
          ..write('serverKey: $serverKey, ')
          ..write('similarId: $similarId, ')
          ..write('similarServerKey: $similarServerKey, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(mediaId, serverKey, similarId, similarServerKey, score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogSimilarItem &&
          other.mediaId == this.mediaId &&
          other.serverKey == this.serverKey &&
          other.similarId == this.similarId &&
          other.similarServerKey == this.similarServerKey &&
          other.score == this.score);
}

class CatalogSimilarItemsCompanion extends UpdateCompanion<CatalogSimilarItem> {
  final Value<String> mediaId;
  final Value<String> serverKey;
  final Value<String> similarId;
  final Value<String> similarServerKey;
  final Value<double> score;
  final Value<int> rowid;
  const CatalogSimilarItemsCompanion({
    this.mediaId = const Value.absent(),
    this.serverKey = const Value.absent(),
    this.similarId = const Value.absent(),
    this.similarServerKey = const Value.absent(),
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogSimilarItemsCompanion.insert({
    required String mediaId,
    required String serverKey,
    required String similarId,
    required String similarServerKey,
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       serverKey = Value(serverKey),
       similarId = Value(similarId),
       similarServerKey = Value(similarServerKey);
  static Insertable<CatalogSimilarItem> custom({
    Expression<String>? mediaId,
    Expression<String>? serverKey,
    Expression<String>? similarId,
    Expression<String>? similarServerKey,
    Expression<double>? score,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (serverKey != null) 'server_key': serverKey,
      if (similarId != null) 'similar_id': similarId,
      if (similarServerKey != null) 'similar_server_key': similarServerKey,
      if (score != null) 'score': score,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogSimilarItemsCompanion copyWith({
    Value<String>? mediaId,
    Value<String>? serverKey,
    Value<String>? similarId,
    Value<String>? similarServerKey,
    Value<double>? score,
    Value<int>? rowid,
  }) {
    return CatalogSimilarItemsCompanion(
      mediaId: mediaId ?? this.mediaId,
      serverKey: serverKey ?? this.serverKey,
      similarId: similarId ?? this.similarId,
      similarServerKey: similarServerKey ?? this.similarServerKey,
      score: score ?? this.score,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (serverKey.present) {
      map['server_key'] = Variable<String>(serverKey.value);
    }
    if (similarId.present) {
      map['similar_id'] = Variable<String>(similarId.value);
    }
    if (similarServerKey.present) {
      map['similar_server_key'] = Variable<String>(similarServerKey.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSimilarItemsCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('serverKey: $serverKey, ')
          ..write('similarId: $similarId, ')
          ..write('similarServerKey: $similarServerKey, ')
          ..write('score: $score, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogSyncStatesTable extends CatalogSyncStates
    with TableInfo<$CatalogSyncStatesTable, CatalogSyncState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogSyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverKeyMeta = const VerificationMeta(
    'serverKey',
  );
  @override
  late final GeneratedColumn<String> serverKey = GeneratedColumn<String>(
    'server_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFullSyncAtMeta = const VerificationMeta(
    'lastFullSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFullSyncAt =
      GeneratedColumn<DateTime>(
        'last_full_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalItemsMeta = const VerificationMeta(
    'totalItems',
  );
  @override
  late final GeneratedColumn<int> totalItems = GeneratedColumn<int>(
    'total_items',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverKey,
    lastSyncAt,
    lastFullSyncAt,
    totalItems,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_sync_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogSyncState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_key')) {
      context.handle(
        _serverKeyMeta,
        serverKey.isAcceptableOrUnknown(data['server_key']!, _serverKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_serverKeyMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('last_full_sync_at')) {
      context.handle(
        _lastFullSyncAtMeta,
        lastFullSyncAt.isAcceptableOrUnknown(
          data['last_full_sync_at']!,
          _lastFullSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('total_items')) {
      context.handle(
        _totalItemsMeta,
        totalItems.isAcceptableOrUnknown(data['total_items']!, _totalItemsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverKey};
  @override
  CatalogSyncState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogSyncState(
      serverKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_key'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      lastFullSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_full_sync_at'],
      ),
      totalItems: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_items'],
      )!,
    );
  }

  @override
  $CatalogSyncStatesTable createAlias(String alias) {
    return $CatalogSyncStatesTable(attachedDatabase, alias);
  }
}

class CatalogSyncState extends DataClass
    implements Insertable<CatalogSyncState> {
  final String serverKey;
  final DateTime? lastSyncAt;
  final DateTime? lastFullSyncAt;
  final int totalItems;
  const CatalogSyncState({
    required this.serverKey,
    this.lastSyncAt,
    this.lastFullSyncAt,
    required this.totalItems,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_key'] = Variable<String>(serverKey);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || lastFullSyncAt != null) {
      map['last_full_sync_at'] = Variable<DateTime>(lastFullSyncAt);
    }
    map['total_items'] = Variable<int>(totalItems);
    return map;
  }

  CatalogSyncStatesCompanion toCompanion(bool nullToAbsent) {
    return CatalogSyncStatesCompanion(
      serverKey: Value(serverKey),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      lastFullSyncAt: lastFullSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFullSyncAt),
      totalItems: Value(totalItems),
    );
  }

  factory CatalogSyncState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogSyncState(
      serverKey: serializer.fromJson<String>(json['serverKey']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      lastFullSyncAt: serializer.fromJson<DateTime?>(json['lastFullSyncAt']),
      totalItems: serializer.fromJson<int>(json['totalItems']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverKey': serializer.toJson<String>(serverKey),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'lastFullSyncAt': serializer.toJson<DateTime?>(lastFullSyncAt),
      'totalItems': serializer.toJson<int>(totalItems),
    };
  }

  CatalogSyncState copyWith({
    String? serverKey,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    Value<DateTime?> lastFullSyncAt = const Value.absent(),
    int? totalItems,
  }) => CatalogSyncState(
    serverKey: serverKey ?? this.serverKey,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    lastFullSyncAt: lastFullSyncAt.present
        ? lastFullSyncAt.value
        : this.lastFullSyncAt,
    totalItems: totalItems ?? this.totalItems,
  );
  CatalogSyncState copyWithCompanion(CatalogSyncStatesCompanion data) {
    return CatalogSyncState(
      serverKey: data.serverKey.present ? data.serverKey.value : this.serverKey,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      lastFullSyncAt: data.lastFullSyncAt.present
          ? data.lastFullSyncAt.value
          : this.lastFullSyncAt,
      totalItems: data.totalItems.present
          ? data.totalItems.value
          : this.totalItems,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSyncState(')
          ..write('serverKey: $serverKey, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastFullSyncAt: $lastFullSyncAt, ')
          ..write('totalItems: $totalItems')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(serverKey, lastSyncAt, lastFullSyncAt, totalItems);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogSyncState &&
          other.serverKey == this.serverKey &&
          other.lastSyncAt == this.lastSyncAt &&
          other.lastFullSyncAt == this.lastFullSyncAt &&
          other.totalItems == this.totalItems);
}

class CatalogSyncStatesCompanion extends UpdateCompanion<CatalogSyncState> {
  final Value<String> serverKey;
  final Value<DateTime?> lastSyncAt;
  final Value<DateTime?> lastFullSyncAt;
  final Value<int> totalItems;
  final Value<int> rowid;
  const CatalogSyncStatesCompanion({
    this.serverKey = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.lastFullSyncAt = const Value.absent(),
    this.totalItems = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogSyncStatesCompanion.insert({
    required String serverKey,
    this.lastSyncAt = const Value.absent(),
    this.lastFullSyncAt = const Value.absent(),
    this.totalItems = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverKey = Value(serverKey);
  static Insertable<CatalogSyncState> custom({
    Expression<String>? serverKey,
    Expression<DateTime>? lastSyncAt,
    Expression<DateTime>? lastFullSyncAt,
    Expression<int>? totalItems,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverKey != null) 'server_key': serverKey,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (lastFullSyncAt != null) 'last_full_sync_at': lastFullSyncAt,
      if (totalItems != null) 'total_items': totalItems,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogSyncStatesCompanion copyWith({
    Value<String>? serverKey,
    Value<DateTime?>? lastSyncAt,
    Value<DateTime?>? lastFullSyncAt,
    Value<int>? totalItems,
    Value<int>? rowid,
  }) {
    return CatalogSyncStatesCompanion(
      serverKey: serverKey ?? this.serverKey,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastFullSyncAt: lastFullSyncAt ?? this.lastFullSyncAt,
      totalItems: totalItems ?? this.totalItems,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverKey.present) {
      map['server_key'] = Variable<String>(serverKey.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (lastFullSyncAt.present) {
      map['last_full_sync_at'] = Variable<DateTime>(lastFullSyncAt.value);
    }
    if (totalItems.present) {
      map['total_items'] = Variable<int>(totalItems.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSyncStatesCompanion(')
          ..write('serverKey: $serverKey, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastFullSyncAt: $lastFullSyncAt, ')
          ..write('totalItems: $totalItems, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogEmbeddingsTable extends CatalogEmbeddings
    with TableInfo<$CatalogEmbeddingsTable, CatalogEmbedding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogEmbeddingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverKeyMeta = const VerificationMeta(
    'serverKey',
  );
  @override
  late final GeneratedColumn<String> serverKey = GeneratedColumn<String>(
    'server_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embeddingMeta = const VerificationMeta(
    'embedding',
  );
  @override
  late final GeneratedColumn<Uint8List> embedding = GeneratedColumn<Uint8List>(
    'embedding',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    serverKey,
    embedding,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_embeddings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogEmbedding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('server_key')) {
      context.handle(
        _serverKeyMeta,
        serverKey.isAcceptableOrUnknown(data['server_key']!, _serverKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_serverKeyMeta);
    }
    if (data.containsKey('embedding')) {
      context.handle(
        _embeddingMeta,
        embedding.isAcceptableOrUnknown(data['embedding']!, _embeddingMeta),
      );
    } else if (isInserting) {
      context.missing(_embeddingMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, serverKey};
  @override
  CatalogEmbedding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogEmbedding(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      serverKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_key'],
      )!,
      embedding: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}embedding'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogEmbeddingsTable createAlias(String alias) {
    return $CatalogEmbeddingsTable(attachedDatabase, alias);
  }
}

class CatalogEmbedding extends DataClass
    implements Insertable<CatalogEmbedding> {
  final String itemId;
  final String serverKey;
  final Uint8List embedding;
  final DateTime updatedAt;
  const CatalogEmbedding({
    required this.itemId,
    required this.serverKey,
    required this.embedding,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['server_key'] = Variable<String>(serverKey);
    map['embedding'] = Variable<Uint8List>(embedding);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogEmbeddingsCompanion toCompanion(bool nullToAbsent) {
    return CatalogEmbeddingsCompanion(
      itemId: Value(itemId),
      serverKey: Value(serverKey),
      embedding: Value(embedding),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogEmbedding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogEmbedding(
      itemId: serializer.fromJson<String>(json['itemId']),
      serverKey: serializer.fromJson<String>(json['serverKey']),
      embedding: serializer.fromJson<Uint8List>(json['embedding']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'serverKey': serializer.toJson<String>(serverKey),
      'embedding': serializer.toJson<Uint8List>(embedding),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogEmbedding copyWith({
    String? itemId,
    String? serverKey,
    Uint8List? embedding,
    DateTime? updatedAt,
  }) => CatalogEmbedding(
    itemId: itemId ?? this.itemId,
    serverKey: serverKey ?? this.serverKey,
    embedding: embedding ?? this.embedding,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogEmbedding copyWithCompanion(CatalogEmbeddingsCompanion data) {
    return CatalogEmbedding(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      serverKey: data.serverKey.present ? data.serverKey.value : this.serverKey,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogEmbedding(')
          ..write('itemId: $itemId, ')
          ..write('serverKey: $serverKey, ')
          ..write('embedding: $embedding, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    serverKey,
    $driftBlobEquality.hash(embedding),
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogEmbedding &&
          other.itemId == this.itemId &&
          other.serverKey == this.serverKey &&
          $driftBlobEquality.equals(other.embedding, this.embedding) &&
          other.updatedAt == this.updatedAt);
}

class CatalogEmbeddingsCompanion extends UpdateCompanion<CatalogEmbedding> {
  final Value<String> itemId;
  final Value<String> serverKey;
  final Value<Uint8List> embedding;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogEmbeddingsCompanion({
    this.itemId = const Value.absent(),
    this.serverKey = const Value.absent(),
    this.embedding = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogEmbeddingsCompanion.insert({
    required String itemId,
    required String serverKey,
    required Uint8List embedding,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       serverKey = Value(serverKey),
       embedding = Value(embedding);
  static Insertable<CatalogEmbedding> custom({
    Expression<String>? itemId,
    Expression<String>? serverKey,
    Expression<Uint8List>? embedding,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (serverKey != null) 'server_key': serverKey,
      if (embedding != null) 'embedding': embedding,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogEmbeddingsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? serverKey,
    Value<Uint8List>? embedding,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogEmbeddingsCompanion(
      itemId: itemId ?? this.itemId,
      serverKey: serverKey ?? this.serverKey,
      embedding: embedding ?? this.embedding,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (serverKey.present) {
      map['server_key'] = Variable<String>(serverKey.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<Uint8List>(embedding.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogEmbeddingsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('serverKey: $serverKey, ')
          ..write('embedding: $embedding, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SearchDatabase extends GeneratedDatabase {
  _$SearchDatabase(QueryExecutor e) : super(e);
  $SearchDatabaseManager get managers => $SearchDatabaseManager(this);
  late final $CatalogIndexItemsTable catalogIndexItems =
      $CatalogIndexItemsTable(this);
  late final $CatalogSimilarItemsTable catalogSimilarItems =
      $CatalogSimilarItemsTable(this);
  late final $CatalogSyncStatesTable catalogSyncStates =
      $CatalogSyncStatesTable(this);
  late final $CatalogEmbeddingsTable catalogEmbeddings =
      $CatalogEmbeddingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogIndexItems,
    catalogSimilarItems,
    catalogSyncStates,
    catalogEmbeddings,
  ];
}

typedef $$CatalogIndexItemsTableCreateCompanionBuilder =
    CatalogIndexItemsCompanion Function({
      required String itemId,
      required String serverKey,
      Value<String> itemServerId,
      required String title,
      Value<String?> itemType,
      Value<String?> overview,
      Value<int?> productionYear,
      Value<double?> communityRating,
      Value<String?> officialRating,
      Value<int?> runTimeTicks,
      Value<String> genresText,
      Value<String> actorsText,
      Value<String> directorsText,
      Value<String?> providerTmdbId,
      Value<String?> providerImdbId,
      required String rawDataJson,
      Value<double> popularityScore,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogIndexItemsTableUpdateCompanionBuilder =
    CatalogIndexItemsCompanion Function({
      Value<String> itemId,
      Value<String> serverKey,
      Value<String> itemServerId,
      Value<String> title,
      Value<String?> itemType,
      Value<String?> overview,
      Value<int?> productionYear,
      Value<double?> communityRating,
      Value<String?> officialRating,
      Value<int?> runTimeTicks,
      Value<String> genresText,
      Value<String> actorsText,
      Value<String> directorsText,
      Value<String?> providerTmdbId,
      Value<String?> providerImdbId,
      Value<String> rawDataJson,
      Value<double> popularityScore,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogIndexItemsTableFilterComposer
    extends Composer<_$SearchDatabase, $CatalogIndexItemsTable> {
  $$CatalogIndexItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemServerId => $composableBuilder(
    column: $table.itemServerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get communityRating => $composableBuilder(
    column: $table.communityRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officialRating => $composableBuilder(
    column: $table.officialRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runTimeTicks => $composableBuilder(
    column: $table.runTimeTicks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genresText => $composableBuilder(
    column: $table.genresText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorsText => $composableBuilder(
    column: $table.actorsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directorsText => $composableBuilder(
    column: $table.directorsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerTmdbId => $composableBuilder(
    column: $table.providerTmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerImdbId => $composableBuilder(
    column: $table.providerImdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get popularityScore => $composableBuilder(
    column: $table.popularityScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogIndexItemsTableOrderingComposer
    extends Composer<_$SearchDatabase, $CatalogIndexItemsTable> {
  $$CatalogIndexItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemServerId => $composableBuilder(
    column: $table.itemServerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get communityRating => $composableBuilder(
    column: $table.communityRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officialRating => $composableBuilder(
    column: $table.officialRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runTimeTicks => $composableBuilder(
    column: $table.runTimeTicks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genresText => $composableBuilder(
    column: $table.genresText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorsText => $composableBuilder(
    column: $table.actorsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directorsText => $composableBuilder(
    column: $table.directorsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerTmdbId => $composableBuilder(
    column: $table.providerTmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerImdbId => $composableBuilder(
    column: $table.providerImdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get popularityScore => $composableBuilder(
    column: $table.popularityScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogIndexItemsTableAnnotationComposer
    extends Composer<_$SearchDatabase, $CatalogIndexItemsTable> {
  $$CatalogIndexItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get serverKey =>
      $composableBuilder(column: $table.serverKey, builder: (column) => column);

  GeneratedColumn<String> get itemServerId => $composableBuilder(
    column: $table.itemServerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => column,
  );

  GeneratedColumn<double> get communityRating => $composableBuilder(
    column: $table.communityRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get officialRating => $composableBuilder(
    column: $table.officialRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get runTimeTicks => $composableBuilder(
    column: $table.runTimeTicks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genresText => $composableBuilder(
    column: $table.genresText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actorsText => $composableBuilder(
    column: $table.actorsText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directorsText => $composableBuilder(
    column: $table.directorsText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerTmdbId => $composableBuilder(
    column: $table.providerTmdbId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerImdbId => $composableBuilder(
    column: $table.providerImdbId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get popularityScore => $composableBuilder(
    column: $table.popularityScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogIndexItemsTableTableManager
    extends
        RootTableManager<
          _$SearchDatabase,
          $CatalogIndexItemsTable,
          CatalogIndexItem,
          $$CatalogIndexItemsTableFilterComposer,
          $$CatalogIndexItemsTableOrderingComposer,
          $$CatalogIndexItemsTableAnnotationComposer,
          $$CatalogIndexItemsTableCreateCompanionBuilder,
          $$CatalogIndexItemsTableUpdateCompanionBuilder,
          (
            CatalogIndexItem,
            BaseReferences<
              _$SearchDatabase,
              $CatalogIndexItemsTable,
              CatalogIndexItem
            >,
          ),
          CatalogIndexItem,
          PrefetchHooks Function()
        > {
  $$CatalogIndexItemsTableTableManager(
    _$SearchDatabase db,
    $CatalogIndexItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogIndexItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogIndexItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogIndexItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> serverKey = const Value.absent(),
                Value<String> itemServerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> itemType = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<int?> productionYear = const Value.absent(),
                Value<double?> communityRating = const Value.absent(),
                Value<String?> officialRating = const Value.absent(),
                Value<int?> runTimeTicks = const Value.absent(),
                Value<String> genresText = const Value.absent(),
                Value<String> actorsText = const Value.absent(),
                Value<String> directorsText = const Value.absent(),
                Value<String?> providerTmdbId = const Value.absent(),
                Value<String?> providerImdbId = const Value.absent(),
                Value<String> rawDataJson = const Value.absent(),
                Value<double> popularityScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogIndexItemsCompanion(
                itemId: itemId,
                serverKey: serverKey,
                itemServerId: itemServerId,
                title: title,
                itemType: itemType,
                overview: overview,
                productionYear: productionYear,
                communityRating: communityRating,
                officialRating: officialRating,
                runTimeTicks: runTimeTicks,
                genresText: genresText,
                actorsText: actorsText,
                directorsText: directorsText,
                providerTmdbId: providerTmdbId,
                providerImdbId: providerImdbId,
                rawDataJson: rawDataJson,
                popularityScore: popularityScore,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String serverKey,
                Value<String> itemServerId = const Value.absent(),
                required String title,
                Value<String?> itemType = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<int?> productionYear = const Value.absent(),
                Value<double?> communityRating = const Value.absent(),
                Value<String?> officialRating = const Value.absent(),
                Value<int?> runTimeTicks = const Value.absent(),
                Value<String> genresText = const Value.absent(),
                Value<String> actorsText = const Value.absent(),
                Value<String> directorsText = const Value.absent(),
                Value<String?> providerTmdbId = const Value.absent(),
                Value<String?> providerImdbId = const Value.absent(),
                required String rawDataJson,
                Value<double> popularityScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogIndexItemsCompanion.insert(
                itemId: itemId,
                serverKey: serverKey,
                itemServerId: itemServerId,
                title: title,
                itemType: itemType,
                overview: overview,
                productionYear: productionYear,
                communityRating: communityRating,
                officialRating: officialRating,
                runTimeTicks: runTimeTicks,
                genresText: genresText,
                actorsText: actorsText,
                directorsText: directorsText,
                providerTmdbId: providerTmdbId,
                providerImdbId: providerImdbId,
                rawDataJson: rawDataJson,
                popularityScore: popularityScore,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogIndexItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$SearchDatabase,
      $CatalogIndexItemsTable,
      CatalogIndexItem,
      $$CatalogIndexItemsTableFilterComposer,
      $$CatalogIndexItemsTableOrderingComposer,
      $$CatalogIndexItemsTableAnnotationComposer,
      $$CatalogIndexItemsTableCreateCompanionBuilder,
      $$CatalogIndexItemsTableUpdateCompanionBuilder,
      (
        CatalogIndexItem,
        BaseReferences<
          _$SearchDatabase,
          $CatalogIndexItemsTable,
          CatalogIndexItem
        >,
      ),
      CatalogIndexItem,
      PrefetchHooks Function()
    >;
typedef $$CatalogSimilarItemsTableCreateCompanionBuilder =
    CatalogSimilarItemsCompanion Function({
      required String mediaId,
      required String serverKey,
      required String similarId,
      required String similarServerKey,
      Value<double> score,
      Value<int> rowid,
    });
typedef $$CatalogSimilarItemsTableUpdateCompanionBuilder =
    CatalogSimilarItemsCompanion Function({
      Value<String> mediaId,
      Value<String> serverKey,
      Value<String> similarId,
      Value<String> similarServerKey,
      Value<double> score,
      Value<int> rowid,
    });

class $$CatalogSimilarItemsTableFilterComposer
    extends Composer<_$SearchDatabase, $CatalogSimilarItemsTable> {
  $$CatalogSimilarItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get similarId => $composableBuilder(
    column: $table.similarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get similarServerKey => $composableBuilder(
    column: $table.similarServerKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogSimilarItemsTableOrderingComposer
    extends Composer<_$SearchDatabase, $CatalogSimilarItemsTable> {
  $$CatalogSimilarItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get similarId => $composableBuilder(
    column: $table.similarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get similarServerKey => $composableBuilder(
    column: $table.similarServerKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogSimilarItemsTableAnnotationComposer
    extends Composer<_$SearchDatabase, $CatalogSimilarItemsTable> {
  $$CatalogSimilarItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get serverKey =>
      $composableBuilder(column: $table.serverKey, builder: (column) => column);

  GeneratedColumn<String> get similarId =>
      $composableBuilder(column: $table.similarId, builder: (column) => column);

  GeneratedColumn<String> get similarServerKey => $composableBuilder(
    column: $table.similarServerKey,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
}

class $$CatalogSimilarItemsTableTableManager
    extends
        RootTableManager<
          _$SearchDatabase,
          $CatalogSimilarItemsTable,
          CatalogSimilarItem,
          $$CatalogSimilarItemsTableFilterComposer,
          $$CatalogSimilarItemsTableOrderingComposer,
          $$CatalogSimilarItemsTableAnnotationComposer,
          $$CatalogSimilarItemsTableCreateCompanionBuilder,
          $$CatalogSimilarItemsTableUpdateCompanionBuilder,
          (
            CatalogSimilarItem,
            BaseReferences<
              _$SearchDatabase,
              $CatalogSimilarItemsTable,
              CatalogSimilarItem
            >,
          ),
          CatalogSimilarItem,
          PrefetchHooks Function()
        > {
  $$CatalogSimilarItemsTableTableManager(
    _$SearchDatabase db,
    $CatalogSimilarItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogSimilarItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogSimilarItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CatalogSimilarItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> mediaId = const Value.absent(),
                Value<String> serverKey = const Value.absent(),
                Value<String> similarId = const Value.absent(),
                Value<String> similarServerKey = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSimilarItemsCompanion(
                mediaId: mediaId,
                serverKey: serverKey,
                similarId: similarId,
                similarServerKey: similarServerKey,
                score: score,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaId,
                required String serverKey,
                required String similarId,
                required String similarServerKey,
                Value<double> score = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSimilarItemsCompanion.insert(
                mediaId: mediaId,
                serverKey: serverKey,
                similarId: similarId,
                similarServerKey: similarServerKey,
                score: score,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogSimilarItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$SearchDatabase,
      $CatalogSimilarItemsTable,
      CatalogSimilarItem,
      $$CatalogSimilarItemsTableFilterComposer,
      $$CatalogSimilarItemsTableOrderingComposer,
      $$CatalogSimilarItemsTableAnnotationComposer,
      $$CatalogSimilarItemsTableCreateCompanionBuilder,
      $$CatalogSimilarItemsTableUpdateCompanionBuilder,
      (
        CatalogSimilarItem,
        BaseReferences<
          _$SearchDatabase,
          $CatalogSimilarItemsTable,
          CatalogSimilarItem
        >,
      ),
      CatalogSimilarItem,
      PrefetchHooks Function()
    >;
typedef $$CatalogSyncStatesTableCreateCompanionBuilder =
    CatalogSyncStatesCompanion Function({
      required String serverKey,
      Value<DateTime?> lastSyncAt,
      Value<DateTime?> lastFullSyncAt,
      Value<int> totalItems,
      Value<int> rowid,
    });
typedef $$CatalogSyncStatesTableUpdateCompanionBuilder =
    CatalogSyncStatesCompanion Function({
      Value<String> serverKey,
      Value<DateTime?> lastSyncAt,
      Value<DateTime?> lastFullSyncAt,
      Value<int> totalItems,
      Value<int> rowid,
    });

class $$CatalogSyncStatesTableFilterComposer
    extends Composer<_$SearchDatabase, $CatalogSyncStatesTable> {
  $$CatalogSyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFullSyncAt => $composableBuilder(
    column: $table.lastFullSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogSyncStatesTableOrderingComposer
    extends Composer<_$SearchDatabase, $CatalogSyncStatesTable> {
  $$CatalogSyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFullSyncAt => $composableBuilder(
    column: $table.lastFullSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogSyncStatesTableAnnotationComposer
    extends Composer<_$SearchDatabase, $CatalogSyncStatesTable> {
  $$CatalogSyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverKey =>
      $composableBuilder(column: $table.serverKey, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFullSyncAt => $composableBuilder(
    column: $table.lastFullSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => column,
  );
}

class $$CatalogSyncStatesTableTableManager
    extends
        RootTableManager<
          _$SearchDatabase,
          $CatalogSyncStatesTable,
          CatalogSyncState,
          $$CatalogSyncStatesTableFilterComposer,
          $$CatalogSyncStatesTableOrderingComposer,
          $$CatalogSyncStatesTableAnnotationComposer,
          $$CatalogSyncStatesTableCreateCompanionBuilder,
          $$CatalogSyncStatesTableUpdateCompanionBuilder,
          (
            CatalogSyncState,
            BaseReferences<
              _$SearchDatabase,
              $CatalogSyncStatesTable,
              CatalogSyncState
            >,
          ),
          CatalogSyncState,
          PrefetchHooks Function()
        > {
  $$CatalogSyncStatesTableTableManager(
    _$SearchDatabase db,
    $CatalogSyncStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogSyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogSyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogSyncStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> serverKey = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime?> lastFullSyncAt = const Value.absent(),
                Value<int> totalItems = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSyncStatesCompanion(
                serverKey: serverKey,
                lastSyncAt: lastSyncAt,
                lastFullSyncAt: lastFullSyncAt,
                totalItems: totalItems,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverKey,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime?> lastFullSyncAt = const Value.absent(),
                Value<int> totalItems = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSyncStatesCompanion.insert(
                serverKey: serverKey,
                lastSyncAt: lastSyncAt,
                lastFullSyncAt: lastFullSyncAt,
                totalItems: totalItems,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogSyncStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$SearchDatabase,
      $CatalogSyncStatesTable,
      CatalogSyncState,
      $$CatalogSyncStatesTableFilterComposer,
      $$CatalogSyncStatesTableOrderingComposer,
      $$CatalogSyncStatesTableAnnotationComposer,
      $$CatalogSyncStatesTableCreateCompanionBuilder,
      $$CatalogSyncStatesTableUpdateCompanionBuilder,
      (
        CatalogSyncState,
        BaseReferences<
          _$SearchDatabase,
          $CatalogSyncStatesTable,
          CatalogSyncState
        >,
      ),
      CatalogSyncState,
      PrefetchHooks Function()
    >;
typedef $$CatalogEmbeddingsTableCreateCompanionBuilder =
    CatalogEmbeddingsCompanion Function({
      required String itemId,
      required String serverKey,
      required Uint8List embedding,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogEmbeddingsTableUpdateCompanionBuilder =
    CatalogEmbeddingsCompanion Function({
      Value<String> itemId,
      Value<String> serverKey,
      Value<Uint8List> embedding,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogEmbeddingsTableFilterComposer
    extends Composer<_$SearchDatabase, $CatalogEmbeddingsTable> {
  $$CatalogEmbeddingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogEmbeddingsTableOrderingComposer
    extends Composer<_$SearchDatabase, $CatalogEmbeddingsTable> {
  $$CatalogEmbeddingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverKey => $composableBuilder(
    column: $table.serverKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogEmbeddingsTableAnnotationComposer
    extends Composer<_$SearchDatabase, $CatalogEmbeddingsTable> {
  $$CatalogEmbeddingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get serverKey =>
      $composableBuilder(column: $table.serverKey, builder: (column) => column);

  GeneratedColumn<Uint8List> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogEmbeddingsTableTableManager
    extends
        RootTableManager<
          _$SearchDatabase,
          $CatalogEmbeddingsTable,
          CatalogEmbedding,
          $$CatalogEmbeddingsTableFilterComposer,
          $$CatalogEmbeddingsTableOrderingComposer,
          $$CatalogEmbeddingsTableAnnotationComposer,
          $$CatalogEmbeddingsTableCreateCompanionBuilder,
          $$CatalogEmbeddingsTableUpdateCompanionBuilder,
          (
            CatalogEmbedding,
            BaseReferences<
              _$SearchDatabase,
              $CatalogEmbeddingsTable,
              CatalogEmbedding
            >,
          ),
          CatalogEmbedding,
          PrefetchHooks Function()
        > {
  $$CatalogEmbeddingsTableTableManager(
    _$SearchDatabase db,
    $CatalogEmbeddingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogEmbeddingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogEmbeddingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogEmbeddingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> serverKey = const Value.absent(),
                Value<Uint8List> embedding = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogEmbeddingsCompanion(
                itemId: itemId,
                serverKey: serverKey,
                embedding: embedding,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String serverKey,
                required Uint8List embedding,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogEmbeddingsCompanion.insert(
                itemId: itemId,
                serverKey: serverKey,
                embedding: embedding,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogEmbeddingsTableProcessedTableManager =
    ProcessedTableManager<
      _$SearchDatabase,
      $CatalogEmbeddingsTable,
      CatalogEmbedding,
      $$CatalogEmbeddingsTableFilterComposer,
      $$CatalogEmbeddingsTableOrderingComposer,
      $$CatalogEmbeddingsTableAnnotationComposer,
      $$CatalogEmbeddingsTableCreateCompanionBuilder,
      $$CatalogEmbeddingsTableUpdateCompanionBuilder,
      (
        CatalogEmbedding,
        BaseReferences<
          _$SearchDatabase,
          $CatalogEmbeddingsTable,
          CatalogEmbedding
        >,
      ),
      CatalogEmbedding,
      PrefetchHooks Function()
    >;

class $SearchDatabaseManager {
  final _$SearchDatabase _db;
  $SearchDatabaseManager(this._db);
  $$CatalogIndexItemsTableTableManager get catalogIndexItems =>
      $$CatalogIndexItemsTableTableManager(_db, _db.catalogIndexItems);
  $$CatalogSimilarItemsTableTableManager get catalogSimilarItems =>
      $$CatalogSimilarItemsTableTableManager(_db, _db.catalogSimilarItems);
  $$CatalogSyncStatesTableTableManager get catalogSyncStates =>
      $$CatalogSyncStatesTableTableManager(_db, _db.catalogSyncStates);
  $$CatalogEmbeddingsTableTableManager get catalogEmbeddings =>
      $$CatalogEmbeddingsTableTableManager(_db, _db.catalogEmbeddings);
}
