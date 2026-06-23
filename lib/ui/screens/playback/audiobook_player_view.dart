import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moonfin_design/moonfin_design.dart';
import 'package:playback_core/playback_core.dart';
import 'package:server_core/server_core.dart';

import '../../../data/models/aggregated_item.dart';
import '../../../data/repositories/item_mutation_repository.dart';
import '../../../data/services/audiobook_bookmarks_service.dart';
import '../../../data/services/audiobook_notes_service.dart';
import '../../../data/services/cast/cast_service.dart';
import '../../../data/services/media_server_client_factory.dart';
import '../../../l10n/app_localizations.dart';
import '../../../playback/sleep_timer_controller.dart';
import '../../../preference/user_preferences.dart';
import '../../../util/focus/dpad_keys.dart';
import '../../../util/platform_detection.dart';
import '../../widgets/audiobook/audiobook_action_rail.dart';
import '../../widgets/audiobook/audiobook_chapter_strip.dart';
import '../../widgets/audiobook/audiobook_drawer.dart';
import '../../widgets/audiobook/audiobook_header.dart';
import '../../widgets/audiobook/audiobook_progress_bar.dart';
import '../../widgets/audiobook/audiobook_sheets.dart';
import '../../widgets/audiobook/audiobook_time.dart';
import '../../widgets/audiobook/audiobook_transport_row.dart';
import '../../widgets/audiobook/chapter.dart';
import '../../widgets/remote_play_to_session_dialog.dart';

enum _AudiobookFocusArea {
  header,
  progress,
  transport,
  actionRail,
  drawerTabs,
  drawerContent,
}

class AudiobookPlayerView extends StatefulWidget {
  const AudiobookPlayerView({super.key});

  @override
  State<AudiobookPlayerView> createState() => _AudiobookPlayerViewState();
}

class _AudiobookPlayerViewState extends State<AudiobookPlayerView> {
  final _manager = GetIt.instance<PlaybackManager>();
  final _castService = GetIt.instance<CastService>();
  final _clientFactory = GetIt.instance<MediaServerClientFactory>();
  final _mutations = GetIt.instance<ItemMutationRepository>();
  final _prefs = GetIt.instance<UserPreferences>();
  final _bookmarks = GetIt.instance<AudiobookBookmarksService>();
  final _notes = GetIt.instance<AudiobookNotesService>();
  final _sleep = GetIt.instance<SleepTimerController>();

  final _subs = <StreamSubscription>[];
  final _tvFocus = FocusNode(debugLabel: 'AudiobookTvFocus');

  AudiobookDrawerTab _drawerTab = AudiobookDrawerTab.chapters;
  bool _drawerOpen = false;
  bool _showRemaining = false;
  bool? _localFavorite;
  String? _favoriteItemId;

  _AudiobookFocusArea _tvArea = _AudiobookFocusArea.transport;
  int _tvHeaderIndex = 0;
  int _tvTransportIndex = 2;
  int _tvRailIndex = 0;
  int _tvTabIndex = 0;

  PlayerState get _state => _manager.state;
  QueueService get _queue => _manager.queueService;

  @override
  void initState() {
    super.initState();
    _showRemaining = _prefs.get(UserPreferences.audiobookShowRemaining);
    final savedTab = _prefs.get(UserPreferences.audiobookDrawerTab);
    _drawerTab = AudiobookDrawerTab.values.firstWhere(
      (t) => t.name == savedTab,
      orElse: () => AudiobookDrawerTab.chapters,
    );

    _subs.addAll([
      _manager.backendChangedStream.listen((_) => _rebuild()),
      _state.playingStream.listen((_) => _rebuild()),
      _state.positionStream.listen((_) => _rebuild()),
      _state.durationStream.listen((_) => _rebuild()),
      _queue.queueChangedStream.listen((_) => _rebuild()),
    ]);
    _sleep.addListener(_rebuild);

    if (PlatformDetection.useNativeVideoSurface) {
      unawaited(_manager.backend?.setVolume(100.0));
    }

    final defaultSpeed = _prefs.get(UserPreferences.audiobookDefaultSpeed);
    if (defaultSpeed > 0 && (defaultSpeed - _state.playbackSpeed).abs() > 0.01) {
      unawaited(_manager.setPlaybackSpeed(defaultSpeed));
    }

    if (PlatformDetection.isTV) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tvFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _sleep.removeListener(_rebuild);
    _tvFocus.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  AggregatedItem? _resolveItem() {
    final current = _queue.currentItem;
    if (current is AggregatedItem) return current;
    final meta = _manager.currentOfflineMetadata;
    if (meta == null) return null;
    return AggregatedItem(
      id: meta['Id'] as String? ?? '',
      serverId: meta['ServerId'] as String? ?? '',
      rawData: meta,
    );
  }

  MediaServerClient _clientForItem(AggregatedItem item) {
    return _clientFactory.getClientIfExists(item.serverId) ??
        GetIt.instance<MediaServerClient>();
  }

  String? _coverUrl(AggregatedItem item) {
    final client = _clientForItem(item);
    if (item.primaryImageTag != null) {
      return client.imageApi
          .getPrimaryImageUrl(item.id, maxHeight: 720, tag: item.primaryImageTag);
    }
    final albumTag = item.albumPrimaryImageTag;
    final albumId = item.albumId;
    if (albumTag != null && albumId != null) {
      return client.imageApi
          .getPrimaryImageUrl(albumId, maxHeight: 720, tag: albumTag);
    }
    return null;
  }

  String? _offlinePosterPath() =>
      _manager.currentOfflineMetadata?['_localPosterPath'] as String?;

  List<Chapter> _chapters(AggregatedItem? item) {
    if (item == null) return const [];
    final out = <Chapter>[];
    for (var i = 0; i < item.chapters.length; i++) {
      final chapter = item.chapters[i];
      final ticks = (chapter['StartPositionTicks'] as num?)?.toInt() ?? 0;
      final title = (chapter['Name'] as String?)?.trim();
      out.add(Chapter(
        title: (title != null && title.isNotEmpty)
            ? title
            : 'Chapter ${i + 1}',
        startMs: ticks ~/ 10000,
      ));
    }
    return out;
  }

  int _currentChapterIndex(List<Chapter> chapters, Duration position) {
    if (chapters.isEmpty) return -1;
    final ms = position.inMilliseconds;
    var idx = 0;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].startMs <= ms) {
        idx = i;
      } else {
        break;
      }
    }
    return idx;
  }

  bool _isFavoriteCurrent(AggregatedItem item) {
    if (_favoriteItemId != item.id) {
      _localFavorite = null;
      _favoriteItemId = item.id;
    }
    return _localFavorite ?? item.isFavorite;
  }

  Future<void> _toggleFavorite(AggregatedItem item) async {
    final next = !_isFavoriteCurrent(item);
    setState(() {
      _localFavorite = next;
      _favoriteItemId = item.id;
    });
    try {
      await _mutations.setFavorite(item.id, isFavorite: next);
    } catch (_) {
      setState(() => _localFavorite = !next);
    }
  }

  String _formatRemaining(Duration position, Duration total) {
    final remaining = total - position;
    final speed = _state.playbackSpeed;
    if (speed <= 0) return '-${formatAudiobookClock(remaining)}';
    final scaled = Duration(
      milliseconds: (remaining.inMilliseconds / speed).round(),
    );
    return '-${formatAudiobookClock(scaled)}';
  }

  Future<void> _setDrawerTab(AudiobookDrawerTab tab) async {
    setState(() => _drawerTab = tab);
    await _prefs.set(UserPreferences.audiobookDrawerTab, tab.name);
  }

  Future<void> _setShowRemaining(bool value) async {
    setState(() => _showRemaining = value);
    await _prefs.set(UserPreferences.audiobookShowRemaining, value);
  }

  Future<void> _skipBack() async {
    final ms = _prefs.get(UserPreferences.skipBackLength);
    final target = _state.position - Duration(milliseconds: ms);
    await _manager.seekTo(target < Duration.zero ? Duration.zero : target);
  }

  Future<void> _skipForward() async {
    final ms = _prefs.get(UserPreferences.skipForwardLength);
    await _manager.seekTo(_state.position + Duration(milliseconds: ms));
  }

  Future<void> _jumpToChapter(Chapter chapter) async {
    await _manager.seekTo(Duration(milliseconds: chapter.startMs));
  }

  Future<void> _previousChapter(List<Chapter> chapters) async {
    if (chapters.isEmpty) {
      await _manager.previous();
      return;
    }
    final current = _currentChapterIndex(chapters, _state.position);
    final pos = _state.position;
    final currentStart = current >= 0 ? chapters[current].startMs : 0;

    if (pos.inMilliseconds - currentStart > 3000 || current <= 0) {
      await _jumpToChapter(chapters[current < 0 ? 0 : current]);
      return;
    }
    await _jumpToChapter(chapters[current - 1]);
  }

  Future<void> _nextChapter(List<Chapter> chapters) async {
    if (chapters.isEmpty) {
      await _manager.next();
      return;
    }
    final current = _currentChapterIndex(chapters, _state.position);
    if (current < 0 || current >= chapters.length - 1) {
      await _manager.next();
      return;
    }
    await _jumpToChapter(chapters[current + 1]);
  }

  Future<void> _addBookmark(AggregatedItem item) async {
    final pos = _state.position;
    final l10n = AppLocalizations.of(context);
    await _bookmarks.add(
      item.serverId,
      item.id,
      positionMs: pos.inMilliseconds,
      label: formatAudiobookClock(pos),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.audiobookBookmarkAdded(formatAudiobookClock(pos)),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openNoteEditor(AggregatedItem item, {AudiobookNote? existing}) async {
    final wasPlaying = _state.isPlaying;
    if (wasPlaying) await _manager.pause();
    if (!mounted) return;
    final pos = existing?.positionMs ?? _state.position.inMilliseconds;
    final result = await showAudiobookNoteEditor(
      context: context,
      initialText: existing?.body ?? '',
      positionLabel: formatAudiobookClock(Duration(milliseconds: pos)),
    );
    if (result != null && result.trim().isNotEmpty) {
      if (existing == null) {
        await _notes.add(
          item.serverId,
          item.id,
          positionMs: pos,
          body: result.trim(),
        );
      } else {
        await _notes.update(
          item.serverId,
          item.id,
          existing.id,
          body: result.trim(),
        );
      }
    }
    if (wasPlaying && mounted) await _manager.resume();
  }

  @override
  Widget build(BuildContext context) {
    final item = _resolveItem();
    final coverUrl = item != null && !_manager.isOfflinePlayback
        ? _coverUrl(item)
        : null;
    final localPoster = _offlinePosterPath();
    final chapters = _chapters(item);

    final layout = LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        return Stack(
          fit: StackFit.expand,
          children: [
            _BlurredBackdrop(
              coverUrl: coverUrl,
              localPosterPath: localPoster,
            ),
            SafeArea(
              child: isWide
                  ? _buildSplitLayout(context, item, coverUrl, localPoster,
                      chapters)
                  : _buildStackedLayout(context, item, coverUrl, localPoster,
                      chapters),
            ),
          ],
        );
      },
    );

    final body = PlatformDetection.isTV
        ? Focus(
            focusNode: _tvFocus,
            autofocus: true,
            onKeyEvent: _handleTvKey,
            child: layout,
          )
        : layout;

    return PopScope(
      canPop: !_drawerOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_drawerOpen) setState(() => _drawerOpen = false);
      },
      child: Scaffold(
        backgroundColor: AppColorScheme.background,
        body: body,
      ),
    );
  }

  Widget _buildStackedLayout(
    BuildContext context,
    AggregatedItem? item,
    String? coverUrl,
    String? localPoster,
    List<Chapter> chapters,
  ) {
    return Column(
      children: [
        AudiobookHeader(
          item: item,
          castService: _castService,
          isTv: PlatformDetection.isTV,
          onClose: () => Navigator.of(context).pop(),
          onCast: item != null ? () => _castToDevice(item) : null,
          onCastSettings: _showCastControls,
          onToggleDrawer: () => setState(() => _drawerOpen = !_drawerOpen),
          drawerOpen: _drawerOpen,
          tvFocusIndex: _tvArea == _AudiobookFocusArea.header ? _tvHeaderIndex : -1,
        ),
        Expanded(
          child: _drawerOpen
              ? _buildDrawer(context, item, chapters)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceLg),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.spaceMd),
                      _CoverArt(
                        coverUrl: coverUrl,
                        localPosterPath: localPoster,
                        size: 260,
                      ),
                      const SizedBox(height: AppSpacing.spaceLg),
                      _TitleBlock(item: item, centered: true),
                      const SizedBox(height: AppSpacing.spaceMd),
                      AudiobookChapterContextStrip(
                        chapters: chapters,
                        position: _state.position,
                        onTap: () => setState(() {
                          _drawerOpen = true;
                          _drawerTab = AudiobookDrawerTab.chapters;
                        }),
                      ),
                    ],
                  ),
                ),
        ),
        _buildBottomControls(context, item, chapters),
      ],
    );
  }

  Widget _buildSplitLayout(
    BuildContext context,
    AggregatedItem? item,
    String? coverUrl,
    String? localPoster,
    List<Chapter> chapters,
  ) {
    final coverSize = PlatformDetection.isTV ? 360.0 : 300.0;
    return Column(
      children: [
        AudiobookHeader(
          item: item,
          castService: _castService,
          isTv: PlatformDetection.isTV,
          onClose: () => Navigator.of(context).pop(),
          onCast: item != null ? () => _castToDevice(item) : null,
          onCastSettings: _showCastControls,
          onToggleDrawer: () => setState(() => _drawerOpen = !_drawerOpen),
          drawerOpen: _drawerOpen,
          tvFocusIndex: _tvArea == _AudiobookFocusArea.header ? _tvHeaderIndex : -1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceXl),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spaceLg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CoverArt(
                          coverUrl: coverUrl,
                          localPosterPath: localPoster,
                          size: coverSize,
                        ),
                        const SizedBox(height: AppSpacing.spaceLg),
                        _TitleBlock(item: item, centered: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceXl),

                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AudiobookChapterContextStrip(
                          chapters: chapters,
                          position: _state.position,
                          onTap: () => setState(() {
                            _drawerOpen = true;
                            _drawerTab = AudiobookDrawerTab.chapters;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.spaceMd),
                        Expanded(
                          child: _drawerOpen
                              ? _buildDrawer(context, item, chapters)
                              : _ActiveTimersPanel(
                                  sleep: _sleep,
                                  onCancelSleep: _sleep.cancel,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomControls(context, item, chapters),
      ],
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    AggregatedItem? item,
    List<Chapter> chapters,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spaceXl,
        AppSpacing.spaceSm,
        AppSpacing.spaceXl,
        AppSpacing.spaceLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AudiobookProgressBar(
            position: _state.position,
            duration: _state.duration,
            chapters: chapters,
            showRemaining: _showRemaining,
            isTvFocused: PlatformDetection.isTV &&
                _tvArea == _AudiobookFocusArea.progress,
            onSeek: (d) => _manager.seekTo(d),
            onToggleRemaining: () => _setShowRemaining(!_showRemaining),
            formatPosition: formatAudiobookClock,
            formatRemaining: _formatRemaining,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          AudiobookTransportRow(
            isPlaying: _state.isPlaying,
            tvFocusIndex: PlatformDetection.isTV &&
                    _tvArea == _AudiobookFocusArea.transport
                ? _tvTransportIndex
                : -1,
            skipBackSeconds:
                _prefs.get(UserPreferences.skipBackLength) ~/ 1000,
            skipForwardSeconds:
                _prefs.get(UserPreferences.skipForwardLength) ~/ 1000,
            onPrevChapter: () => _previousChapter(chapters),
            onSkipBack: _skipBack,
            onPlayPause: () =>
                _state.isPlaying ? _manager.pause() : _manager.resume(),
            onSkipForward: _skipForward,
            onNextChapter: () => _nextChapter(chapters),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          AudiobookActionRail(
            speed: _state.playbackSpeed,
            sleepActive: _sleep.isActive,
            sleepRemaining: _sleep.remaining,
            isFavorite: item != null && _isFavoriteCurrent(item),
            tvFocusIndex: PlatformDetection.isTV &&
                    _tvArea == _AudiobookFocusArea.actionRail
                ? _tvRailIndex
                : -1,
            onOpenSpeed: () => _showSpeedSheet(),
            onOpenSleep: () => _showSleepSheet(chapters),
            onAddBookmark: item == null ? null : () => _addBookmark(item),
            onAddNote: item == null ? null : () => _openNoteEditor(item),
            onToggleFavorite: item == null ? null : () => _toggleFavorite(item),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AggregatedItem? item,
    List<Chapter> chapters,
  ) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
      child: Column(
        children: [
          AudiobookDrawerTabBar(
            current: _drawerTab,
            tvFocused: PlatformDetection.isTV &&
                _tvArea == _AudiobookFocusArea.drawerTabs,
            tvIndex: _tvTabIndex,
            onChanged: _setDrawerTab,
            labels: {
              AudiobookDrawerTab.chapters: l10n.audiobookChapters,
              AudiobookDrawerTab.bookmarks: l10n.audiobookBookmarks,
              AudiobookDrawerTab.notes: l10n.audiobookNotes,
              AudiobookDrawerTab.queue: l10n.audiobookQueue,
            },
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Expanded(
            child: switch (_drawerTab) {
              AudiobookDrawerTab.chapters => AudiobookChaptersList(
                  chapters: chapters,
                  position: _state.position,
                  onTap: (c) => _jumpToChapter(c),
                ),
              AudiobookDrawerTab.bookmarks => AudiobookBookmarksList(
                  item: item,
                  service: _bookmarks,
                  onJump: (b) =>
                      _manager.seekTo(Duration(milliseconds: b.positionMs)),
                ),
              AudiobookDrawerTab.notes => AudiobookNotesList(
                  item: item,
                  service: _notes,
                  onJump: (n) =>
                      _manager.seekTo(Duration(milliseconds: n.positionMs)),
                  onEdit: (n) =>
                      item != null ? _openNoteEditor(item, existing: n) : null,
                ),
              AudiobookDrawerTab.queue => AudiobookQueueList(
                  queue: _queue,
                  onPlay: (i) => _manager.playFromQueue(i),
                ),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSpeedSheet() async {
    await showAudiobookSpeedSheet(
      context: context,
      current: _state.playbackSpeed,
      onChanged: (v) async {
        await _manager.setPlaybackSpeed(v);
        await _prefs.set(UserPreferences.audiobookDefaultSpeed, v);
        if (mounted) setState(() {});
      },
    );
  }

  Future<void> _showSleepSheet(List<Chapter> chapters) async {
    await showAudiobookSleepSheet(
      context: context,
      controller: _sleep,
      onPickPreset: (minutes) async {
        await _prefs.set(UserPreferences.audiobookSleepPresetMin, minutes);
        _sleep.startDuration(Duration(minutes: minutes));
      },
      onPickEndOfChapter: () {
        _sleep.startEndOfChapter(
          chapterStartMsAscending: chapters.map((c) => c.startMs).toList(),
          currentPositionMs: _state.position.inMilliseconds,
          totalDurationMs: _state.duration.inMilliseconds,
        );
      },
      onCancel: _sleep.cancel,
    );
  }

  Future<void> _castToDevice(AggregatedItem item) async {
    await showRemotePlayToSessionDialog(context, item: item);
  }

  Future<void> _showCastControls() async {

  }

  KeyEventResult _handleTvKey(FocusNode node, KeyEvent event) {
    if (!event.isActionable) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key.isBackKey) {
      if (_drawerOpen) {
        setState(() => _drawerOpen = false);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (key.isDirectional) {
      if (key.isUpKey) {
        _moveVertical(-1);
        return KeyEventResult.handled;
      }
      if (key.isDownKey) {
        _moveVertical(1);
        return KeyEventResult.handled;
      }
      if (key.isLeftKey) {
        _moveHorizontal(-1);
        return KeyEventResult.handled;
      }
      if (key.isRightKey) {
        _moveHorizontal(1);
        return KeyEventResult.handled;
      }
    }

    if (key.isSelectKey) {
      _activate();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _moveVertical(int delta) {
    final all = _AudiobookFocusArea.values;
    var idx = all.indexOf(_tvArea);
    final wantsDrawer = _drawerOpen;
    while (true) {
      idx += delta;
      if (idx < 0 || idx >= all.length) return;
      final candidate = all[idx];
      if ((candidate == _AudiobookFocusArea.drawerTabs ||
              candidate == _AudiobookFocusArea.drawerContent) &&
          !wantsDrawer) {
        continue;
      }
      setState(() => _tvArea = candidate);
      return;
    }
  }

  void _moveHorizontal(int delta) {
    setState(() {
      switch (_tvArea) {
        case _AudiobookFocusArea.header:
          _tvHeaderIndex = (_tvHeaderIndex + delta).clamp(0, 2);
          break;
        case _AudiobookFocusArea.progress:

          final step = Duration(milliseconds: 10000 * delta);
          final next = _state.position + step;
          _manager.seekTo(next < Duration.zero ? Duration.zero : next);
          break;
        case _AudiobookFocusArea.transport:
          _tvTransportIndex = (_tvTransportIndex + delta).clamp(0, 4);
          break;
        case _AudiobookFocusArea.actionRail:
          _tvRailIndex = (_tvRailIndex + delta).clamp(0, 4);
          break;
        case _AudiobookFocusArea.drawerTabs:
          _tvTabIndex =
              (_tvTabIndex + delta).clamp(0, AudiobookDrawerTab.values.length - 1);
          _drawerTab = AudiobookDrawerTab.values[_tvTabIndex];
          unawaited(_prefs.set(
              UserPreferences.audiobookDrawerTab, _drawerTab.name));
          break;
        case _AudiobookFocusArea.drawerContent:

          break;
      }
    });
  }

  void _activate() {
    final item = _resolveItem();
    final chapters = _chapters(item);
    switch (_tvArea) {
      case _AudiobookFocusArea.header:
        if (_tvHeaderIndex == 0) {
          Navigator.of(context).pop();
        } else if (_tvHeaderIndex == 1 && item != null) {
          _castToDevice(item);
        } else if (_tvHeaderIndex == 2) {
          setState(() => _drawerOpen = !_drawerOpen);
        }
        break;
      case _AudiobookFocusArea.progress:
        break;
      case _AudiobookFocusArea.transport:
        switch (_tvTransportIndex) {
          case 0:
            _previousChapter(chapters);
            break;
          case 1:
            _skipBack();
            break;
          case 2:
            _state.isPlaying ? _manager.pause() : _manager.resume();
            break;
          case 3:
            _skipForward();
            break;
          case 4:
            _nextChapter(chapters);
            break;
        }
        break;
      case _AudiobookFocusArea.actionRail:
        switch (_tvRailIndex) {
          case 0:
            _showSpeedSheet();
            break;
          case 1:
            _showSleepSheet(chapters);
            break;
          case 2:
            if (item != null) _addBookmark(item);
            break;
          case 3:
            if (item != null) _openNoteEditor(item);
            break;
          case 4:
            if (item != null) _toggleFavorite(item);
            break;
        }
        break;
      case _AudiobookFocusArea.drawerTabs:
        setState(() => _drawerOpen = true);
        break;
      case _AudiobookFocusArea.drawerContent:
        break;
    }
  }
}

class _BlurredBackdrop extends StatelessWidget {
  const _BlurredBackdrop({this.coverUrl, this.localPosterPath});
  final String? coverUrl;
  final String? localPosterPath;

  @override
  Widget build(BuildContext context) {
    Widget? bg;
    if (localPosterPath != null && File(localPosterPath!).existsSync()) {
      bg = Image.file(
        File(localPosterPath!),
        fit: BoxFit.cover,
        color: AppColorScheme.scrim.withValues(alpha: 0.6),
        colorBlendMode: BlendMode.darken,
      );
    } else if (coverUrl != null) {
      bg = CachedNetworkImage(
        imageUrl: coverUrl!,
        fit: BoxFit.cover,
        color: AppColorScheme.scrim.withValues(alpha: 0.6),
        colorBlendMode: BlendMode.darken,
      );
    }
    if (bg == null) return const SizedBox.shrink();
    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: bg,
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({
    this.coverUrl,
    this.localPosterPath,
    required this.size,
  });

  final String? coverUrl;
  final String? localPosterPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    const bookAspectRatio = 0.68;
    final width = size * bookAspectRatio;
    final height = size;

    Widget child;
    if (localPosterPath != null && File(localPosterPath!).existsSync()) {
      child = Image.file(File(localPosterPath!), fit: BoxFit.cover);
    } else if (coverUrl != null) {
      child = CachedNetworkImage(
        imageUrl: coverUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => _placeholder(),
        errorWidget: (_, _, _) => _placeholder(),
      );
    } else {
      child = _placeholder();
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 12,
            right: -4,
            bottom: -8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorScheme.accent.withValues(alpha: 0.18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 38,
                    offset: const Offset(6, 14),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: width, height: height, child: child),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColorScheme.surfaceVariant,
        child: Icon(
          Icons.menu_book,
          size: size * 0.28,
          color: AppColorScheme.onSurface.withValues(alpha: 0.4),
        ),
      );
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.item, this.centered = false});
  final AggregatedItem? item;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final title = item?.name ?? '';
    final author = item?.seriesName ??
        ((item?.rawData['AlbumArtist'] as String?) ??
            (item?.rawData['Artists'] as List?)?.cast<String>().firstOrNull ??
            '');
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: AppColorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (author.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            author,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: AppColorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _ActiveTimersPanel extends StatelessWidget {
  const _ActiveTimersPanel({required this.sleep, required this.onCancelSleep});

  final SleepTimerController sleep;
  final VoidCallback onCancelSleep;

  @override
  Widget build(BuildContext context) {
    if (!sleep.isActive) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Card(
      color: AppColorScheme.surface.withValues(alpha: 0.55),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spaceLg),
        child: Row(
          children: [
            Icon(Icons.bedtime, color: AppColorScheme.accent),
            const SizedBox(width: AppSpacing.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.audiobookSleepTimer,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(l10n.audiobookSleepRemaining(
                      formatAudiobookCountdown(sleep.remaining))),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onCancelSleep,
            ),
          ],
        ),
      ),
    );
  }
}
