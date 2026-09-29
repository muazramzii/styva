import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/address_model.dart';
import '../../../models/checkout_summary_model.dart';
import '../../../providers/address_provider.dart';
import '../../../providers/checkout_provider.dart';
import '../../addresses/widgets/address_summary.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  /// The address the user picked; null means "use the default".
  int? _chosenAddressId;

  /// The chosen address if it still exists, otherwise the default (or first).
  AddressModel? _selectedAddress(List<AddressModel> addresses) {
    return addresses.where((a) => a.id == _chosenAddressId).firstOrNull ??
        addresses.where((a) => a.isDefault).firstOrNull ??
        addresses.firstOrNull;
  }

  Future<void> _addAddress() async {
    final created = await context.push<AddressModel>(AppRoutes.addressNew);
    if (created != null && mounted) setState(() => _chosenAddressId = created.id);
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
    final addressesAsync = ref.watch(addressesProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final isSubmitting = checkoutState is CheckoutLoading || checkoutState is CheckoutSuccess;
    final hasItems = summaryAsync.valueOrNull?.items.isNotEmpty ?? false;
    final selectedAddress = _selectedAddress(addressesAsync.valueOrNull ?? const []);
    final canPlaceOrder = hasItems && selectedAddress != null && !isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          addressesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, _) => Row(
                  children: [
                    Expanded(child: Text('Could not load your addresses: ${extractApiErrorMessage(error)}')),
                    TextButton(onPressed: () => ref.invalidate(addressesProvider), child: const Text('Retry')),
                  ],
                ),
            data:
                (addresses) => _AddressPicker(
                  addresses: addresses,
                  selected: selectedAddress,
                  enabled: !isSubmitting,
                  onSelected: (id) => setState(() => _chosenAddressId = id),
                  onAdd: _addAddress,
                ),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('place_order_button'),
            onPressed: canPlaceOrder ? () => ref.read(checkoutProvider.notifier).placeOrder(selectedAddress.id) : null,
            child:
                isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(hasItems || summaryAsync.isLoading ? 'Place Order' : 'Your cart is empty'),
          ),
        ),
      ),
    );
  }
}

class _AddressPicker extends StatelessWidget {
  const _AddressPicker({
    required this.addresses,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    required this.onAdd,
  });

  final List<AddressModel> addresses;
  final AddressModel? selected;
  final bool enabled;
  final ValueChanged<int> onSelected;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add a shipping address to continue.'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('checkout_add_address'),
            onPressed: enabled ? onAdd : null,
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final address in addresses)
          RadioListTile<int>(
            key: Key('checkout_address_${address.id}'),
            contentPadding: EdgeInsets.zero,
            value: address.id,
            groupValue: selected?.id,
            onChanged: enabled ? (id) => onSelected(id!) : null,
            title: AddressSummary(address: address),
          ),
        TextButton.icon(
          key: const Key('checkout_add_address'),
          onPressed: enabled ? onAdd : null,
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
      ],
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
          TextButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Continue Shopping')),
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
