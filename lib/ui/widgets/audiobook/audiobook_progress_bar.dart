import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonfin_design/moonfin_design.dart';

import '../../../util/platform_detection.dart';
import 'chapter.dart';

class AudiobookProgressBar extends StatelessWidget {
  const AudiobookProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.chapters,
    required this.showRemaining,
    required this.isTvFocused,
    required this.onSeek,
    required this.onToggleRemaining,
    required this.formatPosition,
    required this.formatRemaining,
  });

  final Duration position;
  final Duration duration;
  final List<Chapter> chapters;
  final bool showRemaining;
  final bool isTvFocused;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onToggleRemaining;
  final String Function(Duration) formatPosition;
  final String Function(Duration position, Duration total) formatRemaining;

  @override
  Widget build(BuildContext context) {
    final apple = PlatformDetection.isApple;
    final maxMs = duration.inMilliseconds.toDouble();
    final groupChapters = chapters.length > 40;
    final value = maxMs > 0
        ? position.inMilliseconds.toDouble().clamp(0, maxMs)
        : 0.0;

    final Widget slider;
    if (apple) {
      slider = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CupertinoSlider(
          value: value.toDouble(),
          max: maxMs > 0 ? maxMs : 1,
          activeColor: AppColorScheme.rangeProgress,
          onChanged: (v) => onSeek(Duration(milliseconds: v.toInt())),
        ),
      );
    } else {
      slider = SliderTheme(
        data: SliderThemeData(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: AppColorScheme.rangeProgress,
          inactiveTrackColor: AppColorScheme.rangeTrack,
          thumbColor: isTvFocused ? Colors.white : AppColorScheme.rangeThumb,
          overlayColor: AppColorScheme.rangeThumb.withValues(alpha: 0.2),
        ),
        child: Slider(
          value: value.toDouble(),
          max: maxMs > 0 ? maxMs : 1,
          onChanged: (v) => onSeek(Duration(milliseconds: v.toInt())),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chapters.isNotEmpty)
          SizedBox(
            height: 8,
            child: CustomPaint(
              painter: _ChapterTicksPainter(
                chapters: chapters,
                durationMs: maxMs.toInt(),
                grouped: groupChapters,
                color: AppColorScheme.onSurface.withValues(alpha: 0.5),
              ),
              size: Size.infinite,
            ),
          ),
        slider,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatPosition(position),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              GestureDetector(
                onTap: onToggleRemaining,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  showRemaining
                      ? formatRemaining(position, duration)
                      : formatPosition(duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChapterTicksPainter extends CustomPainter {
  _ChapterTicksPainter({
    required this.chapters,
    required this.durationMs,
    required this.grouped,
    required this.color,
  });

  final List<Chapter> chapters;
  final int durationMs;
  final bool grouped;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (durationMs <= 0) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4;
    if (grouped) {
      final step = (chapters.length / 10).ceil();
      for (var i = 0; i < chapters.length; i += step) {
        final x = (chapters[i].startMs / durationMs) * size.width;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    } else {
      for (final c in chapters) {
        final x = (c.startMs / durationMs) * size.width;
        canvas.drawLine(Offset(x, 1), Offset(x, size.height - 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ChapterTicksPainter old) =>
      old.chapters != chapters || old.durationMs != durationMs;
}
