import 'package:flutter/material.dart';
import 'package:moonfin_design/moonfin_design.dart';

class AudiobookFocusRing extends StatelessWidget {
  const AudiobookFocusRing({
    super.key,
    required this.focused,
    required this.child,
    this.borderRadius,
  });

  final bool focused;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: focused ? AppColorScheme.accent : Colors.transparent,
          width: 2.4,
        ),
        color: focused
            ? AppColorScheme.accent.withValues(alpha: 0.18)
            : Colors.transparent,
      ),
      child: child,
    );
  }
}
