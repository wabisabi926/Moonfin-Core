class ParsedQuery {
  final String originalQuery;
  final String semanticQuery;
  final List<String> actors;
  final List<String> directors;
  final List<String> genres;
  final List<String> itemTypes;
  final int? yearStart;
  final int? yearEnd;
  final SearchSortField? sortField;
  final SearchSortOrder? sortOrder;
  final int? resultLimit;
  final String? ratingSourceKey;

  const ParsedQuery({
    required this.originalQuery,
    required this.semanticQuery,
    this.actors = const [],
    this.directors = const [],
    this.genres = const [],
    this.itemTypes = const [],
    this.yearStart,
    this.yearEnd,
    this.sortField,
    this.sortOrder,
    this.resultLimit,
    this.ratingSourceKey,
  });

  bool get hasStructuredFilters =>
      actors.isNotEmpty ||
      directors.isNotEmpty ||
      genres.isNotEmpty ||
      itemTypes.isNotEmpty ||
      yearStart != null ||
      yearEnd != null ||
      sortField != null ||
      ratingSourceKey != null;
}

enum SearchSortField { rating, year, title }

enum SearchSortOrder { asc, desc }

class QueryParser {
  static final RegExp _topNPattern = RegExp(r'\btop\s+(\d{1,3})\b');
  static final RegExp _fromYearPattern = RegExp(
    r'\bfrom\s+(19\d{2}|20\d{2})\b',
  );
  static final RegExp _inYearPattern = RegExp(r'\bin\s+(19\d{2}|20\d{2})\b');
  static final RegExp _decadePattern = RegExp(r'\b(19\d0|20\d0)s\b');
  static final RegExp _shortDecadePattern = RegExp(r'\b(\d{2})s\b');
  static final RegExp _yearPattern = RegExp(r'\b(19\d{2}|20\d{2})\b');

  static const Map<String, String> _ratingSourceKeywords = {
    'metacritic user': 'metacriticuser',
    'metacriticuser': 'metacriticuser',
    'metacritic': 'metacritic',
    'rotten tomatoes critics': 'tomatoes',
    'rotten tomatoes audience': 'rtaudience',
    'rotten tomatoes': 'tomatoes',
    'imdb': 'imdb',
    'tmdb': 'tmdb',
    'trakt': 'trakt',
    'letterboxd': 'letterboxd',
    'myanimelist': 'myanimelist',
    'ani list': 'anilist',
    'anilist': 'anilist',
  };

  static const Set<String> _knownGenres = {
    'action',
    'adventure',
    'animation',
    'anime',
    'comedy',
    'crime',
    'documentary',
    'drama',
    'family',
    'fantasy',
    'history',
    'horror',
    'music',
    'mystery',
    'romance',
    'sci fi',
    'scifi',
    'science fiction',
    'thriller',
    'war',
    'western',
  };

  ParsedQuery parse(String rawQuery) {
    final trimmed = rawQuery.trim();
    if (trimmed.isEmpty) {
      return const ParsedQuery(originalQuery: '', semanticQuery: '');
    }

    final lower = trimmed.toLowerCase();
    final itemTypes = _extractItemTypes(lower);
    final genres = _extractGenres(lower);
    final yearRange = _extractYearRange(lower);
    final actors = _extractPeople(lower, const ['with ', 'starring ']);
    final directors = _extractPeople(lower, const ['directed by ']);
    final ratingSourceKey = _extractRatingSourceKey(lower);

    final heuristicsActors = _maybeExtractLeadingNameAsActor(
      lower,
      itemTypes: itemTypes,
      genres: genres,
      existingActors: actors,
    );
    final combinedActors = [...actors, ...heuristicsActors];

    final topMatch = _topNPattern.firstMatch(lower);
    final topN = topMatch != null
        ? int.tryParse(topMatch.group(1) ?? '')
        : null;

    SearchSortField? sortField;
    SearchSortOrder? sortOrder;

    if (lower.contains('highest rated') ||
        lower.contains('best') ||
        topN != null) {
      sortField = SearchSortField.rating;
      sortOrder = SearchSortOrder.desc;
    } else if (lower.contains('lowest rated') || lower.contains('worst')) {
      sortField = SearchSortField.rating;
      sortOrder = SearchSortOrder.asc;
    } else if (lower.contains('newest')) {
      sortField = SearchSortField.year;
      sortOrder = SearchSortOrder.desc;
    } else if (lower.contains('oldest')) {
      sortField = SearchSortField.year;
      sortOrder = SearchSortOrder.asc;
    }

    if (ratingSourceKey != null && sortField == null) {
      sortField = SearchSortField.rating;
      sortOrder = SearchSortOrder.desc;
    }

    final semantic = _buildSemanticRemainder(
      trimmed,
      combinedActors,
      directors,
      genres,
      itemTypes,
      ratingSourceKey,
    );

    return ParsedQuery(
      originalQuery: trimmed,
      semanticQuery: semantic,
      actors: _dedupe(combinedActors),
      directors: _dedupe(directors),
      genres: _dedupe(genres),
      itemTypes: _dedupe(itemTypes),
      yearStart: yearRange.$1,
      yearEnd: yearRange.$2,
      sortField: sortField,
      sortOrder: sortOrder,
      resultLimit: topN,
      ratingSourceKey: ratingSourceKey,
    );
  }

  String? _extractRatingSourceKey(String lower) {
    for (final keyword in _ratingSourceKeywords.keys) {
      if (lower.contains(keyword)) {
        return _ratingSourceKeywords[keyword];
      }
    }

    if (lower.contains('mdblist') || lower.contains('mdb list')) {
      return 'imdb';
    }

    return null;
  }

  (int?, int?) _extractYearRange(String lower) {
    final fromMatch = _fromYearPattern.firstMatch(lower);
    if (fromMatch != null) {
      final year = int.tryParse(fromMatch.group(1) ?? '');
      return (year, null);
    }

    final inYearMatch = _inYearPattern.firstMatch(lower);
    if (inYearMatch != null) {
      final year = int.tryParse(inYearMatch.group(1) ?? '');
      return (year, year);
    }

    final decadeMatch = _decadePattern.firstMatch(lower);
    if (decadeMatch != null) {
      final start = int.tryParse(decadeMatch.group(1) ?? '');
      return start == null ? (null, null) : (start, start + 9);
    }

    final shortDecade = _shortDecadePattern.firstMatch(lower);
    if (shortDecade != null) {
      final decadeValue = int.tryParse(shortDecade.group(1) ?? '');
      if (decadeValue != null) {
        final start = decadeValue >= 30
            ? (1900 + decadeValue)
            : (2000 + decadeValue);
        return (start, start + 9);
      }
    }

    final yearMatch = _yearPattern.firstMatch(lower);
    if (yearMatch != null) {
      final year = int.tryParse(yearMatch.group(1) ?? '');
      return (year, year);
    }

    return (null, null);
  }

  List<String> _extractItemTypes(String lower) {
    final itemTypes = <String>[];

    if (lower.contains('movie') ||
        lower.contains('movies') ||
        lower.contains('film') ||
        lower.contains('films')) {
      itemTypes.add('Movie');
    }
    if (lower.contains('show') ||
        lower.contains('shows') ||
        lower.contains('series') ||
        lower.contains('tv')) {
      itemTypes.add('Series');
    }
    if (lower.contains('episode') || lower.contains('episodes')) {
      itemTypes.add('Episode');
    }

    return itemTypes;
  }

  List<String> _extractGenres(String lower) {
    final genres = <String>[];

    for (final genre in _knownGenres) {
      if (lower.contains(genre)) {
        genres.add(_normalizeGenre(genre));
      }
    }

    return genres;
  }

  List<String> _extractPeople(String lower, List<String> prefixes) {
    final people = <String>[];

    for (final prefix in prefixes) {
      final index = lower.indexOf(prefix);
      if (index < 0) continue;
      final start = index + prefix.length;
      var remainder = lower.substring(start).trim();
      if (remainder.isEmpty) continue;

      remainder = remainder
          .split(
            RegExp(
              r'\b(?:from|in|top|best|highest|movies|movie|shows|show|series)\b',
            ),
          )
          .first
          .trim();

      if (remainder.isEmpty) continue;
      if (remainder.length < 3) continue;

      people.add(_titleCaseName(remainder));
    }

    return people;
  }

  List<String> _maybeExtractLeadingNameAsActor(
    String lower, {
    required List<String> itemTypes,
    required List<String> genres,
    required List<String> existingActors,
  }) {
    if (existingActors.isNotEmpty) return const [];
    if (genres.isNotEmpty) return const [];
    if (!(itemTypes.contains('Movie') || itemTypes.contains('Series'))) {
      return const [];
    }

    final marker = RegExp(r'\b(?:movie|movies|film|films|show|shows|series)\b');
    final markerMatch = marker.firstMatch(lower);
    if (markerMatch == null || markerMatch.start <= 0) return const [];

    final candidate = lower.substring(0, markerMatch.start).trim();
    if (candidate.isEmpty || candidate.length > 40) return const [];

    final words = candidate
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.length < 2 || words.length > 3) return const [];

    final stopWords = {
      'top',
      'best',
      'highest',
      'rated',
      'from',
      'in',
      'the',
      'my',
      'library',
    };
    if (words.any(stopWords.contains)) return const [];

    return [_titleCaseName(candidate)];
  }

  String _buildSemanticRemainder(
    String raw,
    List<String> actors,
    List<String> directors,
    List<String> genres,
    List<String> itemTypes,
    String? ratingSourceKey,
  ) {
    var semantic = raw;

    for (final actor in actors) {
      semantic = semantic.replaceAll(RegExp(actor, caseSensitive: false), ' ');
    }
    for (final director in directors) {
      semantic = semantic.replaceAll(
        RegExp(director, caseSensitive: false),
        ' ',
      );
    }
    for (final genre in genres) {
      semantic = semantic.replaceAll(RegExp(genre, caseSensitive: false), ' ');
    }

    final typeTokens = <String>{};
    if (itemTypes.contains('Movie')) {
      typeTokens.addAll(const ['movie', 'movies', 'film', 'films']);
    }
    if (itemTypes.contains('Series')) {
      typeTokens.addAll(const ['show', 'shows', 'series', 'tv']);
    }
    if (itemTypes.contains('Episode')) {
      typeTokens.addAll(const ['episode', 'episodes']);
    }

    for (final token in typeTokens) {
      semantic = semantic.replaceAll(
        RegExp('\\b$token\\b', caseSensitive: false),
        ' ',
      );
    }

    if (ratingSourceKey != null) {
      for (final keyword in _ratingSourceKeywords.keys) {
        semantic = semantic.replaceAll(
          RegExp(keyword, caseSensitive: false),
          ' ',
        );
      }
      semantic = semantic
          .replaceAll(RegExp('mdblist', caseSensitive: false), ' ')
          .replaceAll(RegExp('mdb list', caseSensitive: false), ' ')
          .replaceAll(RegExp('rating', caseSensitive: false), ' ')
          .replaceAll(RegExp('rated', caseSensitive: false), ' ');
    }

    semantic = semantic
        .replaceAll(_topNPattern, ' ')
        .replaceAll(_fromYearPattern, ' ')
        .replaceAll(_inYearPattern, ' ')
        .replaceAll(_decadePattern, ' ')
        .replaceAll(_shortDecadePattern, ' ')
        .replaceAll(_yearPattern, ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return semantic;
  }

  String _normalizeGenre(String genre) {
    if (genre == 'scifi' || genre == 'science fiction') {
      return 'sci fi';
    }
    return genre;
  }

  String _titleCaseName(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          final first = part.substring(0, 1).toUpperCase();
          final rest = part.length > 1 ? part.substring(1).toLowerCase() : '';
          return '$first$rest';
        })
        .join(' ');
  }

  List<String> _dedupe(List<String> values) {
    final seen = <String>{};
    final out = <String>[];
    for (final value in values) {
      final key = value.trim().toLowerCase();
      if (key.isEmpty || !seen.add(key)) continue;
      out.add(value.trim());
    }
    return out;
  }
}
