import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// The STYVA Material 3 theme: ivory pages, white surfaces, charcoal for
/// primary actions and text, warm sand used sparingly. Component themes live
/// here so screens don't hand-style buttons, fields or chips.
class AppTheme {
  AppTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.charcoal,
    onPrimary: AppColors.ivory,
    primaryContainer: AppColors.surfaceMuted,
    onPrimaryContainer: AppColors.charcoal,
    secondary: AppColors.sand,
    onSecondary: AppColors.charcoal,
    secondaryContainer: AppColors.sand,
    onSecondaryContainer: AppColors.charcoal,
    tertiary: AppColors.sandDark,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.surfaceMuted,
    onTertiaryContainer: AppColors.charcoal,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: Color(0xFFF6E3E1),
    onErrorContainer: AppColors.error,
    surface: AppColors.white,
    onSurface: AppColors.charcoal,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: AppColors.white,
    surfaceContainer: AppColors.ivory,
    surfaceContainerHigh: AppColors.surfaceMuted,
    surfaceContainerHighest: AppColors.surfaceMuted,
    outline: AppColors.outline,
    outlineVariant: AppColors.border,
    shadow: Color(0x1A000000),
    scrim: Color(0x66000000),
    inverseSurface: AppColors.charcoal,
    onInverseSurface: AppColors.ivory,
    inversePrimary: AppColors.sand,
    surfaceTint: Colors.transparent,
  );

  static final ThemeData lightTheme = _build();

  static ThemeData _build() {
    final text = AppTypography.textTheme;
    const squareish = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)));
    const buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md);
    const buttonMinSize = Size(64, AppSpacing.buttonHeight);

    // Primary (filled/elevated) buttons: charcoal with ivory text; disabled
    // keeps 3.9:1 text contrast instead of Material's faint default.
    final primaryButtonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(buttonMinSize),
      padding: const WidgetStatePropertyAll(buttonPadding),
      shape: const WidgetStatePropertyAll(squareish),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(text.labelLarge),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? AppColors.surfaceMuted : AppColors.charcoal,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? AppColors.disabledText : AppColors.ivory,
      ),
      overlayColor: const WidgetStatePropertyAll(Color(0x1FF6F3EE)),
    );

    final outlinedButtonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(buttonMinSize),
      padding: const WidgetStatePropertyAll(buttonPadding),
      shape: const WidgetStatePropertyAll(squareish),
      textStyle: WidgetStatePropertyAll(text.labelLarge),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? AppColors.disabledText : AppColors.charcoal,
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled) ? AppColors.border : AppColors.charcoal,
        ),
      ),
      overlayColor: const WidgetStatePropertyAll(Color(0x14222222)),
    );

    OutlineInputBorder fieldBorder(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ivory,
      canvasColor: AppColors.ivory,
      fontFamily: AppTypography.sans,
      textTheme: text,
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.charcoal,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.border,
        centerTitle: true,
        titleTextStyle: text.titleMedium?.copyWith(letterSpacing: 0.4),
        iconTheme: const IconThemeData(color: AppColors.charcoal, size: 22),
        actionsIconTheme: const IconThemeData(color: AppColors.charcoal, size: 22),
      ),
      iconTheme: const IconThemeData(color: AppColors.charcoal, size: 22),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      filledButtonTheme: FilledButtonThemeData(style: primaryButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(48, 44)),
          shape: const WidgetStatePropertyAll(squareish),
          textStyle: WidgetStatePropertyAll(text.labelLarge),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) ? AppColors.disabledText : AppColors.charcoal,
          ),
          overlayColor: const WidgetStatePropertyAll(Color(0x14222222)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) ? AppColors.disabledText : AppColors.charcoal,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
        labelStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: AppColors.charcoal),
        hintStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        helperStyle: text.bodySmall,
        errorStyle: text.bodySmall?.copyWith(color: AppColors.error),
        errorMaxLines: 3,
        border: fieldBorder(AppColors.outline),
        enabledBorder: fieldBorder(AppColors.outline),
        focusedBorder: fieldBorder(AppColors.charcoal, 1.5),
        errorBorder: fieldBorder(AppColors.error),
        focusedErrorBorder: fieldBorder(AppColors.error, 1.5),
        disabledBorder: fieldBorder(AppColors.border),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.charcoal,
        selectionColor: Color(0x40B7A58A),
        selectionHandleColor: AppColors.charcoal,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg))),
        titleTextStyle: text.headlineSmall,
        contentTextStyle: text.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.surfaceMuted,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: AppColors.charcoal)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.charcoal,
        disabledColor: AppColors.surfaceMuted,
        checkmarkColor: AppColors.ivory,
        side: const BorderSide(color: AppColors.outline),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md))),
        labelStyle: text.labelLarge?.copyWith(letterSpacing: 0.3),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: AppColors.ivory, letterSpacing: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        showCheckmark: false,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.charcoal,
        linearTrackColor: AppColors.surfaceMuted,
        circularTrackColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.ivory),
        actionTextColor: AppColors.sand,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md))),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.charcoal,
        textColor: AppColors.charcoal,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        minVerticalPadding: AppSpacing.md,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? AppColors.disabledText : AppColors.charcoal,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.charcoal : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.ivory),
        side: const BorderSide(color: AppColors.outline, width: 1.5),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.ivory : AppColors.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.charcoal : AppColors.surfaceMuted,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.charcoal : AppColors.outline,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.ivory,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md))),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        textStyle: text.bodySmall?.copyWith(color: AppColors.ivory),
      ),
    );
  }
}
