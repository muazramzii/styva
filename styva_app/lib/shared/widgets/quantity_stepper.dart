import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Bordered − quantity + control used by the product page and the cart.
/// A null callback disables that side (e.g. at quantity 1 or at stock).
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.quantity, required this.onDecrease, required this.onIncrease});

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(tooltip: 'Decrease quantity', onPressed: onDecrease, icon: const Icon(Icons.remove, size: 18)),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 28),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
              semanticsLabel: 'Quantity $quantity',
            ),
          ),
          IconButton(tooltip: 'Increase quantity', onPressed: onIncrease, icon: const Icon(Icons.add, size: 18)),
        ],
      ),
    );
  }
}
