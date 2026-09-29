import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

/// DEVELOPMENT ONLY. Stands in for a payment gateway's page while only the
/// mock provider exists. It deliberately looks like a test tool, not a bank:
/// no card or login fields, and a clear "simulated" banner. The backend only
/// accepts these simulations when PAYMENT_MOCK_ENABLED is on.
class MockPaymentPage extends ConsumerWidget {
  const MockPaymentPage({super.key, required this.paymentId});

  final String paymentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(paymentId);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('STYVA Test Payment')),
        body: Center(child: Text('Invalid payment id: $paymentId')),
      );
    }

    final paymentAsync = ref.watch(paymentDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('STYVA Test Payment')),
      body: paymentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load payment: $error')),
        data: (payment) => _MockPaymentBody(payment: payment),
      ),
    );
  }
}

class _MockPaymentBody extends ConsumerWidget {
  const _MockPaymentBody({required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider(payment.orderId));
    final isLoading = paymentState is PaymentLoading;
    final isPending = payment.status == PaymentStatus.pending;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.science_outlined, color: colors.onTertiaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Development only — simulated payment. No real money is '
                  'charged and no bank is contacted.',
                  style: TextStyle(color: colors.onTertiaryContainer),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Order', style: textTheme.labelLarge),
        Text(payment.orderNumber, style: textTheme.titleMedium),
        const SizedBox(height: 16),
        Text('Payment reference', style: textTheme.labelLarge),
        Text(payment.reference, style: textTheme.titleMedium),
        const SizedBox(height: 16),
        Text('Amount', style: textTheme.labelLarge),
        Text(formatMoney(payment.amount), style: textTheme.headlineSmall),
        const SizedBox(height: 32),
        if (isPending) ...[
          FilledButton(
            onPressed: isLoading ? null : () => _simulate(context, ref, PaymentStatus.success),
            child: const Text('Simulate Success'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: isLoading ? null : () => _simulate(context, ref, PaymentStatus.failed),
            child: const Text('Simulate Failure'),
          ),
          if (isLoading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ] else ...[
          Text(
            'This test payment is already ${formatStatus(payment.status).toLowerCase()}.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _leave(context),
            child: const Text('Back to Order'),
          ),
        ],
        if (paymentState is PaymentError) ...[
          const SizedBox(height: 12),
          Text(paymentState.message, style: TextStyle(color: colors.error)),
        ],
      ],
    );
  }

  Future<void> _simulate(BuildContext context, WidgetRef ref, String outcome) async {
    final result = await ref
        .read(paymentProvider(payment.orderId).notifier)
        .simulateMockOutcome(payment.id, outcome);
    if (result == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        result.status == PaymentStatus.success ? 'Payment successful' : 'Payment failed',
      ),
    ));
    _leave(context);
  }

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/orders/${payment.orderId}');
    }
  }
}
