import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/styva_wordmark.dart';

/// Shared frame for the sign-in and registration forms: wordmark, editorial
/// heading, then the form. Scrolls, so the keyboard or large text never
/// cause overflow, and stays a comfortable width on wide screens.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: StyvaWordmark(size: 30)),
                  const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
                  Text(title, style: textTheme.displaySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(subtitle, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xl),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline form-level error (e.g. wrong credentials), in the theme's error colour.
class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        liveRegion: true,
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

/// Spinner sized for use inside a primary button while a request runs.
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2));
  }
}
