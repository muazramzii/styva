import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';
import '../../../shared/widgets/state_message.dart';
import '../../../shared/widgets/status_badge.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => StateMessage.error(
              title: 'Could not load your orders',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(ordersProvider),
            ),
        data: (orders) {
          if (orders.isEmpty) {
            return StateMessage(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Your orders will appear here once you check out.',
              actionLabel: 'Start Shopping',
              onAction: () => context.go(AppRoutes.home),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(ordersProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(indent: AppSpacing.page, endIndent: AppSpacing.page),
              itemBuilder: (context, index) {
                final order = orders[index];
                return InkWell(
                  onTap: () => context.push('/orders/${order.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.lg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.orderNumber, style: textTheme.titleSmall),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${formatDate(order.createdAt)} · ${order.itemCount} '
                                '${order.itemCount == 1 ? 'item' : 'items'}',
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              StatusBadge(status: order.status),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(formatMoney(order.total), style: AppTypography.price),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
