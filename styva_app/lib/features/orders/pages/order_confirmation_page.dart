import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';
import '../widgets/order_payment_section.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(orderId);
    if (id == null) {
      return Scaffold(body: Center(child: Text('Invalid order id: $orderId')));
    }

    final orderAsync = ref.watch(orderDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed'), automaticallyImplyLeading: false),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load order: $error')),
        data: (order) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle_outline, size: 56),
              const SizedBox(height: 16),
              Text(
                'Order placed successfully',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text('Order: ${order.orderNumber}', textAlign: TextAlign.center),
              Text('Total: ${formatMoney(order.total)}', textAlign: TextAlign.center),
              Text('Status: ${formatStatus(order.status)}', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OrderPaymentSection(order: order),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/orders/${order.id}'),
                child: const Text('View Order'),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
