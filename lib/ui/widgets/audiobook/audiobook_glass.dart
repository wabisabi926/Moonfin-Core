import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

import '../../../util/platform_detection.dart';

const double kAudiobookButtonSize = 46;

bool get audiobookGlassEligible => PlatformDetection.isApple && !kIsWeb;

Widget audiobookGlassOrSolid({
  required Widget child,
  required Color fallbackColor,
  double cornerRadius = 14,
  double blur = 14,
  Color? veilColor,
  Color? tint,
  Border? border,
}) {
  final radius = BorderRadius.circular(cornerRadius);

  if (!audiobookGlassEligible) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fallbackColor,
        borderRadius: radius,
        border: border,
      ),
      child: child,
    );
  }

  final veil = veilColor ?? const Color(0x24FFFFFF);

  return DecoratedBox(
    decoration: BoxDecoration(borderRadius: radius),
    child: ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(child: ColoredBox(color: veil)),
            if (tint != null) Positioned.fill(child: ColoredBox(color: tint)),
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GlassHairlinePainter(radius: cornerRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _GlassHairlinePainter extends CustomPainter {
  const _GlassHairlinePainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x59FFFFFF), Color(0x0FFFFFFF)],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GlassHairlinePainter oldDelegate) =>
      oldDelegate.radius != radius;
}
