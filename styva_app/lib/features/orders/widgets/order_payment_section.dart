import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/order_model.dart';
import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

/// Payment status for an order plus the action to pay it. What is shown is
/// driven by the order's server-side `payment_status`, never by local state.
class OrderPaymentSection extends ConsumerWidget {
  const OrderPaymentSection({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (order.status == 'cancelled') return const SizedBox.shrink();

    final paymentState = ref.watch(paymentProvider(order.id));
    final isLoading = paymentState is PaymentLoading;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isPaid = order.paymentStatus == PaymentStatus.success || order.status == 'paid';
    final isFailed = order.paymentStatus == PaymentStatus.failed;

    final (IconData icon, String label, Color color) = isPaid
        ? (Icons.check_circle, 'Paid', Colors.green.shade700)
        : isFailed
            ? (Icons.error, 'Payment Failed', colors.error)
            : (Icons.schedule, 'Payment Pending', colors.onSurfaceVariant);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(label, style: textTheme.titleMedium?.copyWith(color: color)),
              ],
            ),
            if (!isPaid) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: isLoading ? null : () => _pay(context, ref),
                child: isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isFailed ? 'Try Again' : 'Pay Now'),
              ),
            ],
            if (paymentState is PaymentError) ...[
              const SizedBox(height: 8),
              Text(paymentState.message, style: TextStyle(color: colors.error)),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    final payment = await ref.read(paymentProvider(order.id).notifier).startPayment();
    if (payment == null || !context.mounted) return;
    // Only the development mock provider exists so far; real providers will
    // hand back a redirect to their own payment page here instead.
    if (payment.status == PaymentStatus.pending && payment.provider == 'mock') {
      context.push('/payments/${payment.id}/mock');
    }
  }
}
