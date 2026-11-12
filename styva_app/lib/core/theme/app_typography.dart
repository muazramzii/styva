import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Two families:
/// - Cormorant Garamond (high-contrast serif) for editorial display and
///   headline styles only -- page heroes, section titles, product names on
///   the detail page.
/// - Lato (clean sans-serif) for everything practical: titles, body, labels,
///   prices, form fields, validation messages.
///
/// Both are bundled (OFL) so text renders the same offline. If a font ever
/// fails to load, the platform default is used; sizes and weights still hold.
class AppTypography {
  AppTypography._();

  static const String serif = 'CormorantGaramond';
  static const String sans = 'Lato';

  // Cormorant Garamond is a variable font, so its weight is set on the axis.
  static TextStyle _serif(double size, double weight, {double height = 1.15, double spacing = 0}) {
    return TextStyle(
      fontFamily: serif,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      fontWeight: weight >= 600 ? FontWeight.w600 : FontWeight.w500,
      fontVariations: [FontVariation('wght', weight)],
      color: AppColors.charcoal,
    );
  }

  static TextStyle _sans(double size, FontWeight weight, {double height = 1.4, double spacing = 0, Color? color}) {
    return TextStyle(
      fontFamily: sans,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      fontWeight: weight,
      color: color ?? AppColors.charcoal,
    );
  }

  static final TextTheme textTheme = TextTheme(
    displayLarge: _serif(44, 500, height: 1.05, spacing: -0.5),
    displayMedium: _serif(36, 500, height: 1.1, spacing: -0.25),
    displaySmall: _serif(30, 500),
    headlineLarge: _serif(28, 600),
    headlineMedium: _serif(24, 600),
    headlineSmall: _serif(21, 600),
    titleLarge: _sans(18, FontWeight.w600, height: 1.3),
    titleMedium: _sans(16, FontWeight.w600, height: 1.35),
    titleSmall: _sans(14, FontWeight.w600, height: 1.35),
    bodyLarge: _sans(16, FontWeight.w400, height: 1.5),
    bodyMedium: _sans(14, FontWeight.w400, height: 1.45),
    bodySmall: _sans(12, FontWeight.w400, height: 1.4, color: AppColors.textSecondary),
    labelLarge: _sans(14, FontWeight.w600, spacing: 0.6),
    labelMedium: _sans(12, FontWeight.w600, spacing: 0.8),
    labelSmall: _sans(11, FontWeight.w600, spacing: 1.0, color: AppColors.textSecondary),
  );

  /// Small uppercase caption for brand names and section eyebrows.
  static final TextStyle eyebrow = _sans(11, FontWeight.w600, spacing: 1.6, color: AppColors.textSecondary);

  /// Prices: same sans family, slightly heavier, tabular figures so columns line up.
  static final TextStyle price = _sans(15, FontWeight.w600).copyWith(
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
