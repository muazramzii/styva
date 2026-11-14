import 'package:flutter/material.dart';

/// A form-level error from the server (e.g. "Current password is incorrect"),
/// in the theme's error colour. Announced to screen readers when it appears.
class FormErrorText extends StatelessWidget {
  const FormErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
    );
  }
}
