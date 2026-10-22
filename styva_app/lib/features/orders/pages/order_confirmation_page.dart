import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/order_provider.dart';
import '../../../shared/widgets/state_message.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/order_payment_section.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(orderId);
    if (id == null) {
      return Scaffold(
        body: StateMessage(
          icon: Icons.search_off,
          title: 'Order not found',
          actionLabel: 'Back to Home',
          onAction: () => context.go(AppRoutes.home),
        ),
      );
    }

    final orderAsync = ref.watch(orderDetailProvider(id));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed'), automaticallyImplyLeading: false),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => StateMessage.error(
              title: 'Could not load your order',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(orderDetailProvider(id)),
            ),
        // Scrolls so short screens and large text never overflow.
        data:
            (order) => Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Order placed successfully', textAlign: TextAlign.center, style: textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Thank you for shopping with STYVA.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            _Detail(label: 'Order', value: Text(order.orderNumber, style: textTheme.titleSmall)),
                            _Detail(label: 'Total', value: Text(formatMoney(order.total), style: AppTypography.price)),
                            _Detail(label: 'Status', value: StatusBadge(status: order.status)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OrderPaymentSection(order: order),
                    const SizedBox(height: AppSpacing.xl),
                    // Secondary: Pay Now (in the payment section) stays the one primary action.
                    OutlinedButton(onPressed: () => context.go('/orders/${order.id}'), child: const Text('View Order')),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Continue Shopping')),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label.toUpperCase(), style: AppTypography.eyebrow), value],
      ),
    );
  }
}
