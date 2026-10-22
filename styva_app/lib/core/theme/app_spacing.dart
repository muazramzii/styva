/// Spacing and corner-radius scale. Corners stay small and restrained to keep
/// the editorial, tailored look (no oversized rounded components).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal page gutter.
  static const double page = 20;

  /// Minimum height for primary actions (comfortably above the 48dp target).
  static const double buttonHeight = 52;
}

class AppRadius {
  AppRadius._();

  static const double sm = 2;
  static const double md = 4;
  static const double lg = 8;
}
