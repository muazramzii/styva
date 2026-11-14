import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../models/address_model.dart';

/// Recipient, phone and address lines for a saved address, as shown in the
/// address list and at checkout.
class AddressSummary extends StatelessWidget {
  const AddressSummary({super.key, required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(child: Text(address.recipientName, style: textTheme.titleSmall)),
            if (address.isDefault) ...[const SizedBox(width: AppSpacing.sm), const DefaultAddressBadge()],
          ],
        ),
        const SizedBox(height: 2),
        for (final line in [
          address.phone,
          address.addressLine1,
          if (address.addressLine2.isNotEmpty) address.addressLine2,
          '${address.postcode} ${address.city}, ${address.state}',
        ])
          Text(line, style: textTheme.bodyMedium),
      ],
    );
  }
}

/// Marks the default address. Styled like the order status badges: charcoal
/// on warm sand (6.6:1).
class DefaultAddressBadge extends StatelessWidget {
  const DefaultAddressBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(
        'DEFAULT',
        semanticsLabel: 'Default',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.charcoal, letterSpacing: 1.0),
      ),
    );
  }
}
