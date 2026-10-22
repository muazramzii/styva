import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// The STYVA name as a typographic wordmark.
///
/// INTERIM: this is set in the brand's editorial serif with wide tracking as a
/// stand-in. It is not the final logo artwork. When the clean logo files are
/// delivered (see assets/brand/README.md), replace the [Text] below with an
/// image of `styva_wordmark_dark` / `styva_wordmark_light`; every screen
/// already goes through this widget, so nothing else needs to change.
class StyvaWordmark extends StatelessWidget {
  const StyvaWordmark({super.key, this.size = 22, this.color = AppColors.charcoal});

  /// Light wordmark for dark backgrounds (e.g. the splash screen).
  const StyvaWordmark.light({super.key, this.size = 22}) : color = AppColors.ivory;

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'STYVA',
      header: true,
      excludeSemantics: true,
      child: Text(
        'STYVA',
        textScaler: TextScaler.noScaling, // a logo keeps its proportions
        maxLines: 1,
        style: TextStyle(
          fontFamily: AppTypography.serif,
          fontSize: size,
          height: 1,
          letterSpacing: size * 0.14,
          fontWeight: FontWeight.w500,
          fontVariations: const [FontVariation('wght', 520)],
          color: color,
        ),
      ),
    );
  }
}
