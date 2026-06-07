import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A [CachedNetworkImage] whose decoded pixel width is bounded to the
/// rendered widget width times the device pixel ratio, optionally clamped
/// and/or scaled. This keeps the in-memory image cache from holding decodes
/// far larger than what is actually painted (a common source of jank and
/// large RAM usage on web).
class BoundedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Alignment alignment;
  final Duration fadeInDuration;
  final Widget Function(BuildContext context, String url, Object error)?
      errorBuilder;

  /// Multiplier applied to the resolved width before clamping. Useful for
  /// blurred images where a low-resolution decode is acceptable.
  final double scale;

  /// Lower bound for the decoded width in physical pixels.
  final int minWidth;

  /// Upper bound for the decoded width in physical pixels.
  final int maxWidth;

  const BoundedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.fadeInDuration = Duration.zero,
    this.errorBuilder,
    this.scale = 1.0,
    this.minWidth = 64,
    this.maxWidth = 1024,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cacheW = (constraints.maxWidth * dpr * scale)
            .round()
            .clamp(minWidth, maxWidth);
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          alignment: alignment,
          fadeInDuration: fadeInDuration,
          memCacheWidth: cacheW,
          maxWidthDiskCache: cacheW,
          errorWidget: errorBuilder == null
              ? null
              : (context, url, error) => errorBuilder!(context, url, error),
        );
      },
    );
  }
}
