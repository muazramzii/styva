import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';

/// Small label for an order status (pending, paid, packing, shipping,
/// delivered, cancelled). Text colours keep at least 4.5:1 contrast on their
/// tinted backgrounds.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (status) {
      'paid' || 'delivered' => (const Color(0xFFE4EFE8), AppColors.success),
      'packing' || 'shipping' => (AppColors.sand, AppColors.charcoal),
      'cancelled' => (const Color(0xFFF6E3E1), AppColors.error),
      _ => (AppColors.surfaceMuted, AppColors.charcoal),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(
        formatStatus(status).toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground, letterSpacing: 1.0),
      ),
    );
  }
}
