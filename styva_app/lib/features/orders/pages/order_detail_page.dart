import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(orderId);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order')),
        body: Center(child: Text('Invalid order id: $orderId')),
      );
    }

    final orderAsync = ref.watch(orderDetailProvider(id));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load order: $error')),
        data: (order) {
          final address = order.shippingAddress;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(order.orderNumber, style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Placed ${formatDate(order.createdAt)}'),
              const SizedBox(height: 8),
              Text('Status: ${formatStatus(order.status)}'),
              Text('Payment: ${formatStatus(order.paymentStatus)}'),
              const SizedBox(height: 24),
              Text('Items', style: textTheme.titleMedium),
              for (final item in order.items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.productName),
                  subtitle: Text(
                    '${item.brand} · ${item.size} / ${item.color} · '
                    '${item.quantity} × ${formatMoney(item.unitPrice)}',
                  ),
                  trailing: Text(formatMoney(item.subtotal)),
                ),
              if (address != null) ...[
                const SizedBox(height: 24),
                Text('Shipping Address', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(address.fullName),
                Text(address.phone),
                Text(address.addressLine1),
                if (address.addressLine2.isNotEmpty) Text(address.addressLine2),
                Text('${address.postcode} ${address.city}, ${address.state}'),
              ],
              const Divider(height: 32),
              _row('Subtotal', formatMoney(order.subtotal)),
              _row('Shipping', formatMoney(order.shippingFee)),
              _row('Total', formatMoney(order.total), style: textTheme.titleMedium),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
