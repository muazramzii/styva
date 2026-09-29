import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load orders: $error')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('You have no orders yet'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(ordersProvider.future),
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  onTap: () => context.go('/orders/${order.id}'),
                  title: Text(order.orderNumber),
                  subtitle: Text('${formatDate(order.createdAt)} · ${formatStatus(order.status)}'),
                  trailing: Text(formatMoney(order.total)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
