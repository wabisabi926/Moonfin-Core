import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonfin_design/moonfin_design.dart';

import '../../../util/platform_detection.dart';
import 'audiobook_focus_ring.dart';
import 'audiobook_glass.dart';
import 'audiobook_time.dart';

class AudiobookActionRail extends StatelessWidget {
  const AudiobookActionRail({
    super.key,
    required this.speed,
    required this.sleepActive,
    required this.sleepRemaining,
    required this.isFavorite,
    required this.tvFocusIndex,
    required this.onOpenSpeed,
    required this.onOpenSleep,
    required this.onAddBookmark,
    required this.onAddNote,
    required this.onToggleFavorite,
  });

  final double speed;
  final bool sleepActive;
  final Duration sleepRemaining;
  final bool isFavorite;
  final int tvFocusIndex;
  final VoidCallback onOpenSpeed;
  final VoidCallback onOpenSleep;
  final VoidCallback? onAddBookmark;
  final VoidCallback? onAddNote;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final apple = PlatformDetection.isApple;

    final entries = <_RailEntry>[
      _RailEntry(
        icon: apple ? CupertinoIcons.speedometer : Icons.speed,
        label: '${speed.toStringAsFixed(speed == speed.toInt() ? 1 : 2)}x',
        accent: (speed - 1.0).abs() > 0.01,
        onTap: onOpenSpeed,
      ),
      _RailEntry(
        icon: apple
            ? (sleepActive ? CupertinoIcons.moon_fill : CupertinoIcons.moon)
            : (sleepActive ? Icons.bedtime : Icons.bedtime_outlined),
        label: sleepActive ? formatAudiobookCompact(sleepRemaining) : null,
        accent: sleepActive,
        onTap: onOpenSleep,
      ),
      _RailEntry(
        icon: apple ? CupertinoIcons.bookmark : Icons.bookmark_add_outlined,
        onTap: onAddBookmark,
      ),
      _RailEntry(
        icon: apple ? CupertinoIcons.pencil : Icons.edit_note,
        onTap: onAddNote,
      ),
      _RailEntry(
        icon: isFavorite
            ? (apple ? CupertinoIcons.heart_fill : Icons.favorite)
            : (apple ? CupertinoIcons.heart : Icons.favorite_border),
        accent: isFavorite,
        onTap: onToggleFavorite,
      ),
    ];

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < entries.length; i++)
          AudiobookFocusRing(
            focused: tvFocusIndex == i,
            child: entries[i].build(apple: apple),
          ),
      ],
    );

    return audiobookGlassOrSolid(
      cornerRadius: 18,
      fallbackColor: const Color(0x00000000),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: row,
      ),
    );
  }
}

class _RailEntry {
  _RailEntry({required this.icon, this.label, this.accent = false, this.onTap});

  final IconData icon;
  final String? label;
  final bool accent;
  final VoidCallback? onTap;

  Widget build({required bool apple}) {
    final color = accent
        ? AppColorScheme.accent
        : AppColorScheme.onSurface.withValues(
            alpha: onTap == null ? 0.4 : 0.85,
          );

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        if (label != null) ...[
          const SizedBox(height: 2),
          Text(
            label!,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (apple) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        onPressed: onTap,
        child: child,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: child,
      ),
    );
  }
}
