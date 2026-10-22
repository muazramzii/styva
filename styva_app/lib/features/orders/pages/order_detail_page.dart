import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';
import '../../../shared/widgets/state_message.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/order_payment_section.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(orderId);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order')),
        body: const StateMessage(
          icon: Icons.search_off,
          title: 'Order not found',
          message: 'This link does not point to one of your orders.',
        ),
      );
    }

    final orderAsync = ref.watch(orderDetailProvider(id));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => StateMessage.error(
              title: 'Could not load this order',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(orderDetailProvider(id)),
            ),
        data: (order) {
          final address = order.shippingAddress;
          return ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.xxl),
            children: [
              // Sans-serif: the serif's old-style figures make an order number hard to read.
              Text(order.orderNumber, style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text('Placed ${formatDate(order.createdAt)}', style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Row(children: [StatusBadge(status: order.status)]),
              const SizedBox(height: AppSpacing.lg),
              OrderPaymentSection(order: order),
              const _SectionTitle('Items'),
              for (final item in order.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.brand.toUpperCase(), style: AppTypography.eyebrow),
                            const SizedBox(height: 2),
                            Text(item.productName, style: textTheme.bodyLarge),
                            Text(
                              '${item.size} / ${item.color} · ${item.quantity} × ${formatMoney(item.unitPrice)}',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(formatMoney(item.subtotal), style: AppTypography.price),
                    ],
                  ),
                ),
              if (address != null) ...[
                const _SectionTitle('Shipping Address'),
                Text(address.fullName, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                for (final line in [
                  address.phone,
                  address.addressLine1,
                  if (address.addressLine2.isNotEmpty) address.addressLine2,
                  '${address.postcode} ${address.city}, ${address.state}',
                ])
                  Text(line, style: textTheme.bodyMedium),
              ],
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              _TotalRow(label: 'Subtotal', value: formatMoney(order.subtotal)),
              _TotalRow(label: 'Shipping', value: formatMoney(order.shippingFee)),
              _TotalRow(label: 'Total', value: formatMoney(order.total), emphasize: true),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Text(title.toUpperCase(), style: AppTypography.eyebrow),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasize ? textTheme.titleMedium : textTheme.bodyMedium),
          Text(value, style: emphasize ? AppTypography.price.copyWith(fontSize: 18) : AppTypography.price),
        ],
      ),
    );
  }
}
