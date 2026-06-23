import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonfin_design/moonfin_design.dart';
import 'package:playback_core/playback_core.dart';

import '../../../data/models/aggregated_item.dart';
import '../../../data/services/audiobook_bookmarks_service.dart';
import '../../../data/services/audiobook_notes_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../util/platform_detection.dart';
import 'audiobook_time.dart';
import 'chapter.dart';

enum AudiobookDrawerTab { chapters, bookmarks, notes, queue }

class AudiobookDrawerTabBar extends StatelessWidget {
  const AudiobookDrawerTabBar({
    super.key,
    required this.current,
    required this.onChanged,
    required this.labels,
    required this.tvFocused,
    required this.tvIndex,
  });

  final AudiobookDrawerTab current;
  final ValueChanged<AudiobookDrawerTab> onChanged;
  final Map<AudiobookDrawerTab, String> labels;
  final bool tvFocused;
  final int tvIndex;

  @override
  Widget build(BuildContext context) {
    final tabs = AudiobookDrawerTab.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            AudiobookPillSegment(
              label: labels[tabs[i]] ?? tabs[i].name,
              selected: tabs[i] == current,
              tvFocused: tvFocused && tvIndex == i,
              onTap: () => onChanged(tabs[i]),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class AudiobookPillSegment extends StatelessWidget {
  const AudiobookPillSegment({
    super.key,
    required this.label,
    required this.selected,
    required this.tvFocused,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool tvFocused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final apple = PlatformDetection.isApple;

    final Color bg;
    final Color fg;
    if (selected) {
      if (apple) {
        bg = AppColorScheme.accent.withValues(alpha: 0.18);
        fg = AppColorScheme.accent;
      } else {
        bg = AppColorScheme.accent;
        fg = AppColorScheme.onAccent;
      }
    } else {
      bg = AppColorScheme.surface.withValues(alpha: 0.6);
      fg = AppColorScheme.onSurface.withValues(alpha: 0.85);
    }

    final borderColor = tvFocused
        ? Colors.white
        : (selected && apple ? AppColorScheme.accent : Colors.transparent);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: tvFocused ? 2.2 : 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AudiobookChaptersList extends StatelessWidget {
  const AudiobookChaptersList({
    super.key,
    required this.chapters,
    required this.position,
    required this.onTap,
  });

  final List<Chapter> chapters;
  final Duration position;
  final ValueChanged<Chapter> onTap;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return _EmptyState(
        text: AppLocalizations.of(context).audiobookNoChapters,
      );
    }
    var current = 0;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].startMs <= position.inMilliseconds) {
        current = i;
      } else {
        break;
      }
    }
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final c = chapters[index];
        final isCurrent = index == current;
        return ListTile(
          dense: true,
          onTap: () => onTap(c),
          leading: SizedBox(
            width: 36,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFeatures: const [FontFeature.tabularFigures()],
                color: isCurrent
                    ? AppColorScheme.accent
                    : AppColorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text(
            c.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isCurrent ? AppColorScheme.accent : null,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          trailing: Text(
            formatAudiobookClock(Duration(milliseconds: c.startMs)),
            style: TextStyle(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: AppColorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class AudiobookBookmarksList extends StatelessWidget {
  const AudiobookBookmarksList({
    super.key,
    required this.item,
    required this.service,
    required this.onJump,
  });

  final AggregatedItem? item;
  final AudiobookBookmarksService service;
  final ValueChanged<AudiobookBookmark> onJump;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();
    final apple = PlatformDetection.isApple;
    return StreamBuilder<List<AudiobookBookmark>>(
      stream: service.watch(item!.serverId, item!.id),
      initialData: const [],
      builder: (context, snapshot) {
        final list = snapshot.data ?? const [];
        if (list.isEmpty) {
          return _EmptyState(
            text: AppLocalizations.of(context).audiobookNoBookmarks,
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final b = list[index];
            return ListTile(
              leading: Icon(
                apple ? CupertinoIcons.bookmark_fill : Icons.bookmark,
                color: AppColorScheme.accent,
              ),
              title: Text(b.label),
              subtitle: Text(
                b.createdAt.toLocal().toString().split('.').first,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  apple ? CupertinoIcons.delete : Icons.delete_outline,
                ),
                onPressed: () =>
                    service.removeAt(item!.serverId, item!.id, b.positionMs),
              ),
              onTap: () => onJump(b),
            );
          },
        );
      },
    );
  }
}

class AudiobookNotesList extends StatelessWidget {
  const AudiobookNotesList({
    super.key,
    required this.item,
    required this.service,
    required this.onJump,
    required this.onEdit,
  });

  final AggregatedItem? item;
  final AudiobookNotesService service;
  final ValueChanged<AudiobookNote> onJump;
  final ValueChanged<AudiobookNote> onEdit;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();
    final apple = PlatformDetection.isApple;
    return StreamBuilder<List<AudiobookNote>>(
      stream: service.watch(item!.serverId, item!.id),
      initialData: const [],
      builder: (context, snapshot) {
        final list = snapshot.data ?? const [];
        if (list.isEmpty) {
          return _EmptyState(
            text: AppLocalizations.of(context).audiobookNoNotes,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final n = list[index];
            return ListTile(
              isThreeLine: true,
              title: Text(
                formatAudiobookClock(Duration(milliseconds: n.positionMs)),
                style: TextStyle(
                  color: AppColorScheme.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  n.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () => onJump(n),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      apple ? CupertinoIcons.pencil : Icons.edit_outlined,
                      size: 20,
                    ),
                    onPressed: () => onEdit(n),
                  ),
                  IconButton(
                    icon: Icon(
                      apple ? CupertinoIcons.delete : Icons.delete_outline,
                      size: 20,
                    ),
                    onPressed: () =>
                        service.remove(item!.serverId, item!.id, n.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AudiobookQueueList extends StatelessWidget {
  const AudiobookQueueList({
    super.key,
    required this.queue,
    required this.onPlay,
  });

  final QueueService queue;
  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    final items = queue.items;
    final current = queue.currentIndex;
    if (items.isEmpty) {
      return _EmptyState(text: AppLocalizations.of(context).queueIsEmpty);
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final raw = items[index];
        final item = raw is AggregatedItem ? raw : null;
        final isCurrent = index == current;
        return ListTile(
          title: Text(
            item?.name ?? AppLocalizations.of(context).trackNumber(index + 1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isCurrent ? AppColorScheme.accent : null,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          onTap: () => onPlay(index),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: AppColorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
