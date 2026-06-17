import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:server_core/server_core.dart';

import '../../l10n/current_app_localizations.dart';
import '../models/aggregated_item.dart';
import '../repositories/search_repository.dart';
import '../repositories/seerr_repository.dart';
import '../services/local_media_search_service.dart';
import '../services/seerr/seerr_api_models.dart';

class SearchResultGroup {
  final String title;
  final List<String> itemTypes;
  final List<AggregatedItem> items;

  const SearchResultGroup({
    required this.title,
    required this.itemTypes,
    this.items = const [],
  });

  SearchResultGroup copyWith({List<AggregatedItem>? items}) =>
      SearchResultGroup(
        title: title,
        itemTypes: itemTypes,
        items: items ?? this.items,
      );
}

enum SearchState { idle, loading, ready, error }

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;
  final MediaServerClient _client;
  final LocalMediaSearchService _localSearchService;
  final String? _scopedParentId;
  SeerrRepository? _seerrRepository;

  SearchViewModel(
    this._searchRepository,
    this._client, {
    required LocalMediaSearchService localSearchService,
    SeerrRepository? seerrRepository,
    String? scopedParentId,
  }) : _localSearchService = localSearchService,
       _seerrRepository = seerrRepository,
       _scopedParentId = (scopedParentId != null && scopedParentId.isNotEmpty)
           ? scopedParentId
           : null;

  void setSeerrRepository(SeerrRepository repo) {
    _seerrRepository = repo;
  }

  ImageApi get imageApi => _client.imageApi;

  SearchState _state = SearchState.idle;
  SearchState get state => _state;

  String _query = '';
  String get query => _query;

  List<SearchResultGroup> _results = const [];
  List<SearchResultGroup> get results => _results;

  List<SeerrDiscoverItem> _seerrResults = const [];
  List<SeerrDiscoverItem> get seerrResults => _seerrResults;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Timer? _debounceTimer;

  static const _debounceMs = 600;
  static const _resultLimit = 24;
  static const _globalFetchLimit = 240;

  static const _bookSearchGroupItemTypes = [
    ['Book'],
    ['AudioBook'],
  ];

  static const _searchGroupItemTypes = [
    ['Book'],
    ['Movie'],
    ['Series'],
    ['Season'],
    ['Episode'],
    ['Video'],
    ['MusicVideo'],
    ['Trailer'],
    ['Program'],
    ['LiveTvChannel'],
    ['Playlist'],
    ['MusicArtist', 'AlbumArtist'],
    ['MusicAlbum'],
    ['Audio'],
    ['PhotoAlbum'],
    ['Photo'],
    ['BoxSet'],
    ['Person'],
    ['Folder', 'CollectionFolder', 'UserView'],
  ];

  static List<SearchResultGroup> _bookSearchGroups() {
    final l10n = currentAppLocalizations();
    return [
      SearchResultGroup(
        title: l10n.books,
        itemTypes: _bookSearchGroupItemTypes[0],
      ),
      SearchResultGroup(
        title: l10n.audiobooks,
        itemTypes: _bookSearchGroupItemTypes[1],
      ),
    ];
  }

  static List<SearchResultGroup> _searchGroups() {
    final l10n = currentAppLocalizations();
    return [
      SearchResultGroup(title: l10n.books, itemTypes: _searchGroupItemTypes[0]),
      SearchResultGroup(
        title: l10n.movies,
        itemTypes: _searchGroupItemTypes[1],
      ),
      SearchResultGroup(
        title: l10n.series,
        itemTypes: _searchGroupItemTypes[2],
      ),
      SearchResultGroup(
        title: l10n.seasons,
        itemTypes: _searchGroupItemTypes[3],
      ),
      SearchResultGroup(
        title: l10n.episodes,
        itemTypes: _searchGroupItemTypes[4],
      ),
      SearchResultGroup(
        title: l10n.videos,
        itemTypes: _searchGroupItemTypes[5],
      ),
      SearchResultGroup(
        title: l10n.musicVideos,
        itemTypes: _searchGroupItemTypes[6],
      ),
      SearchResultGroup(
        title: l10n.trailers,
        itemTypes: _searchGroupItemTypes[7],
      ),
      SearchResultGroup(
        title: l10n.programs,
        itemTypes: _searchGroupItemTypes[8],
      ),
      SearchResultGroup(
        title: l10n.channels,
        itemTypes: _searchGroupItemTypes[9],
      ),
      SearchResultGroup(
        title: l10n.playlists,
        itemTypes: _searchGroupItemTypes[10],
      ),
      SearchResultGroup(
        title: l10n.artists,
        itemTypes: _searchGroupItemTypes[11],
      ),
      SearchResultGroup(
        title: l10n.albums,
        itemTypes: _searchGroupItemTypes[12],
      ),
      SearchResultGroup(
        title: l10n.songs,
        itemTypes: _searchGroupItemTypes[13],
      ),
      SearchResultGroup(
        title: l10n.photoAlbums,
        itemTypes: _searchGroupItemTypes[14],
      ),
      SearchResultGroup(
        title: l10n.photos,
        itemTypes: _searchGroupItemTypes[15],
      ),
      SearchResultGroup(
        title: l10n.collections,
        itemTypes: _searchGroupItemTypes[16],
      ),
      SearchResultGroup(
        title: l10n.people,
        itemTypes: _searchGroupItemTypes[17],
      ),
      SearchResultGroup(
        title: l10n.folders,
        itemTypes: _searchGroupItemTypes[18],
      ),
    ];
  }

  void searchDebounced(String query) {
    final trimmed = query.trim();
    if (trimmed == _query) return;
    _query = trimmed;

    _debounceTimer?.cancel();

    if (trimmed.isEmpty) {
      _results = const [];
      _seerrResults = const [];
      _state = SearchState.idle;
      notifyListeners();
      return;
    }

    _state = SearchState.loading;
    notifyListeners();

    _debounceTimer = Timer(
      const Duration(milliseconds: _debounceMs),
      () => _executeSearch(trimmed),
    );
  }

  void searchImmediate(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _query = trimmed;
    _debounceTimer?.cancel();
    _state = SearchState.loading;
    notifyListeners();
    _executeSearch(trimmed);
  }

  Future<void> _executeSearch(String query) async {
    if (query != _query) return;

    try {
      final activeGroups = _scopedParentId != null
          ? _bookSearchGroups()
          : _searchGroups();
      final seerrFuture = _fetchSeerrResults(query);
      final localFuture = _scopedParentId != null
          ? Future.value(LocalSearchResult.empty(query))
          : _localSearchService
                .search(query)
                .catchError((_) => LocalSearchResult.empty(query));

      final groups = _scopedParentId != null
          ? await Future.wait(
              activeGroups.map((group) async {
                final items = await _searchRepository.search(
                  query,
                  includeItemTypes: group.itemTypes,
                  parentId: _scopedParentId,
                  limit: _resultLimit,
                );
                return group.copyWith(items: items);
              }),
            )
          : _mergeLocalResults(
              await _buildGroupedGlobalResults(query, activeGroups),
              await localFuture,
            );
      final seerr = await seerrFuture;

      if (query != _query) return;

      _results = groups.where((g) => g.items.isNotEmpty).toList();
      _seerrResults = seerr;
      _state = SearchState.ready;
    } catch (e) {
      if (query != _query) return;
      _errorMessage = e.toString();
      _state = SearchState.error;
    }
    notifyListeners();
  }

  List<SearchResultGroup> _mergeLocalResults(
    List<SearchResultGroup> serverGroups,
    LocalSearchResult localResult,
  ) {
    final localItems = localResult.items;
    if (localItems.isEmpty) return serverGroups;

    final mergedGroups = <SearchResultGroup>[];
    for (final group in serverGroups) {
      final localForGroup = localItems
          .where((item) => group.itemTypes.contains(item.type))
          .toList();

      if (localResult.preferLocalOnly) {
        mergedGroups.add(
          group.copyWith(items: localForGroup.take(_resultLimit).toList()),
        );
        continue;
      }

      final mergedById = <String, AggregatedItem>{};
      for (final item in localForGroup) {
        mergedById[_itemKey(item)] = item;
      }
      for (final item in group.items) {
        mergedById.putIfAbsent(_itemKey(item), () => item);
      }

      mergedGroups.add(
        group.copyWith(items: mergedById.values.take(_resultLimit).toList()),
      );
    }

    return mergedGroups;
  }

  String _itemKey(AggregatedItem item) => '${item.serverId}:${item.id}';

  Future<List<AggregatedItem>> moreLikeThis(String mediaId) {
    return _localSearchService.moreLikeThis(mediaId);
  }

  Future<List<SearchResultGroup>> _buildGroupedGlobalResults(
    String query,
    List<SearchResultGroup> activeGroups,
  ) async {
    final allItems = await _searchRepository.search(
      query,
      parentId: _scopedParentId,
      limit: _globalFetchLimit,
    );

    final grouped = <SearchResultGroup>[];
    for (final group in activeGroups) {
      final matched = allItems
          .where((item) => group.itemTypes.contains(item.type))
          .take(_resultLimit)
          .toList();
      grouped.add(group.copyWith(items: matched));
    }

    return grouped;
  }

  Future<List<SeerrDiscoverItem>> _fetchSeerrResults(String query) async {
    if (_scopedParentId != null) return const [];
    if (query.trim().toLowerCase().startsWith('studio:')) return const [];
    final repo = _seerrRepository;
    if (repo == null) return const [];
    try {
      await repo.ensureInitialized();
      if (!repo.isAvailable) return const [];
      final page = await repo.search(query, limit: _resultLimit);
      return page.results;
    } catch (_) {
      return const [];
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
