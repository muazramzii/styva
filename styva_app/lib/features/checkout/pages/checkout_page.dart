import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/checkout_summary_model.dart';
import '../../../models/shipping_address_model.dart';
import '../../../providers/checkout_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _addressLine1 = TextEditingController();
  final _addressLine2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postcode = TextEditingController();

  @override
  void dispose() {
    for (final controller in [
      _fullName, _phone, _addressLine1, _addressLine2, _city, _state, _postcode,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(checkoutProvider.notifier).placeOrder(
          ShippingAddressModel(
            fullName: _fullName.text.trim(),
            phone: _phone.text.trim(),
            addressLine1: _addressLine1.text.trim(),
            addressLine2: _addressLine2.text.trim(),
            city: _city.text.trim(),
            state: _state.text.trim(),
            postcode: _postcode.text.trim(),
          ),
        );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CheckoutState>(checkoutProvider, (previous, next) {
      switch (next) {
        case CheckoutSuccess(:final order):
          context.go('/order-confirmation/${order.id}');
        case CheckoutError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        default:
          break;
      }
    });

    final summaryAsync = ref.watch(checkoutSummaryProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final isSubmitting = checkoutState is CheckoutLoading || checkoutState is CheckoutSuccess;
    final hasItems = summaryAsync.valueOrNull?.items.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('checkout_full_name'),
              controller: _fullName,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => _required(v, 'Full name'),
            ),
            TextFormField(
              key: const Key('checkout_phone'),
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (v) {
                final required = _required(v, 'Phone');
                if (required != null) return required;
                if (!RegExp(r'^\+?[0-9][0-9\s-]{6,19}$').hasMatch(v!.trim())) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('checkout_address_line_1'),
              controller: _addressLine1,
              decoration: const InputDecoration(labelText: 'Address line 1'),
              validator: (v) => _required(v, 'Address'),
            ),
            TextFormField(
              key: const Key('checkout_address_line_2'),
              controller: _addressLine2,
              decoration: const InputDecoration(labelText: 'Address line 2 (optional)'),
            ),
            TextFormField(
              key: const Key('checkout_city'),
              controller: _city,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (v) => _required(v, 'City'),
            ),
            TextFormField(
              key: const Key('checkout_state'),
              controller: _state,
              decoration: const InputDecoration(labelText: 'State'),
              validator: (v) => _required(v, 'State'),
            ),
            TextFormField(
              key: const Key('checkout_postcode'),
              controller: _postcode,
              decoration: const InputDecoration(labelText: 'Postcode'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final required = _required(v, 'Postcode');
                if (required != null) return required;
                if (!RegExp(r'^\d{5}$').hasMatch(v!.trim())) return 'Enter a valid 5-digit postcode';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Order Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            summaryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Could not load your cart: $error'),
              data: (summary) => _OrderSummary(summary: summary),
            ),
            const SizedBox(height: 24),
            Text('Payment', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.payment_outlined),
              title: Text('Payment method'),
              subtitle: Text('Coming in next phase'),
            ),
            if (checkoutState case CheckoutError(:final message))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(message, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('place_order_button'),
            onPressed: hasItems && !isSubmitting ? _placeOrder : null,
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(hasItems || summaryAsync.isLoading ? 'Place Order' : 'Your cart is empty'),
          ),
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.summary});

  final CheckoutSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    if (summary.items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your cart is empty'),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Continue Shopping'),
          ),
        ],
      );
    }

    return Column(
      children: [
        for (final item in summary.items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.variant.product?.name ?? 'Product'),
            subtitle: Text(
              '${item.variant.size} / ${item.variant.color} · '
              '${item.quantity} × ${formatMoney(item.variant.product?.price ?? 0)}',
            ),
            trailing: Text(formatMoney(item.subtotal)),
          ),
        const Divider(),
        _SummaryRow(label: 'Subtotal', value: formatMoney(summary.subtotal)),
        _SummaryRow(label: 'Shipping', value: formatMoney(summary.shippingFee)),
        _SummaryRow(label: 'Total', value: formatMoney(summary.total), emphasize: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize ? Theme.of(context).textTheme.titleMedium : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
