import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// A product photo with a calm placeholder while loading and when there is
/// no image or it fails to load (the seeded catalogue currently has only
/// placeholder filenames, so failures are expected in development).
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    this.aspectRatio = 3 / 4,
    this.label,
    this.borderRadius = 0,
  });

  final String? url;
  final double aspectRatio;

  /// Shown on the fallback (typically the brand name) so the tile still
  /// reads as a product rather than a broken image.
  final String? label;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ColoredBox(
          color: AppColors.surfaceMuted,
          child: image == null || image.isEmpty
              ? _Fallback(label: label)
              : Image.network(
                  image,
                  fit: BoxFit.cover,
                  semanticLabel: label,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return const SizedBox.expand();
                  },
                  errorBuilder: (context, error, stackTrace) => _Fallback(label: label),
                ),
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 96;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.checkroom_outlined, size: compact ? 22 : 32, color: AppColors.textSecondary),
              if (!compact && label != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    label!.toUpperCase(),
                    style: AppTypography.eyebrow,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
