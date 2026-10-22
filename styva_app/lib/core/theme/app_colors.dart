import 'package:flutter/material.dart';

/// STYVA brand palette. Screens should use these tokens (or the derived
/// `Theme.of(context).colorScheme`) rather than literal colours.
///
/// Contrast (WCAG 2.1) was checked for every text pairing:
/// - charcoal on ivory 14.4:1, on white 15.9:1
/// - textSecondary on ivory 5.2:1, on white 5.8:1
/// - sandDark on ivory 4.9:1 -- use it, not [sand], for accent *text*
/// - sand on ivory is only 2.2:1, so [sand] is for surfaces/lines, with
///   charcoal text on top (6.6:1)
/// - outline on white 3.6:1 (meets 3:1 for field boundaries)
/// - disabledText on disabledSurface 3.9:1, on ivory 4.4:1
/// - error on ivory 6.7:1, success on ivory 5.7:1
class AppColors {
  AppColors._();

  /// Page background.
  static const Color ivory = Color(0xFFF6F3EE);

  /// Primary text, primary buttons, icons, strong emphasis.
  static const Color charcoal = Color(0xFF222222);

  /// Restrained secondary accent (badges, selected markers, thin rules).
  static const Color sand = Color(0xFFB7A58A);

  /// Darker sand, safe for small accent text on light backgrounds.
  static const Color sandDark = Color(0xFF7A6749);

  /// Cards, sheets, text fields.
  static const Color white = Color(0xFFFFFFFF);

  /// Muted secondary text (captions, metadata, helper text).
  static const Color textSecondary = Color(0xFF6B655D);

  /// Text-field and outlined-control borders.
  static const Color outline = Color(0xFF8C857B);

  /// Subtle dividers and card borders (decorative, not a control boundary).
  static const Color border = Color(0xFFD9D2C7);

  /// Image placeholders, unselected chips, disabled button fills.
  static const Color surfaceMuted = Color(0xFFE8E3DB);

  static const Color disabledText = Color(0xFF767065);

  static const Color error = Color(0xFFA3261E);
  static const Color success = Color(0xFF2F6B4F);
}
