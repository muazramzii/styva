import 'package:flutter/material.dart';

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
            if (address.isDefault) ...[
              const SizedBox(width: 8),
              const DefaultAddressBadge(),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(address.phone),
        Text(address.addressLine1),
        if (address.addressLine2.isNotEmpty) Text(address.addressLine2),
        Text('${address.postcode} ${address.city}, ${address.state}'),
      ],
    );
  }
}

class DefaultAddressBadge extends StatelessWidget {
  const DefaultAddressBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Default',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSecondaryContainer),
      ),
    );
  }
}
