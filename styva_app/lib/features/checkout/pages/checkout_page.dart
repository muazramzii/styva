import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/address_model.dart';
import '../../../models/checkout_summary_model.dart';
import '../../../providers/address_provider.dart';
import '../../../providers/checkout_provider.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/form_error_text.dart';
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
          // The chosen address may have been deleted elsewhere ("Address not
          // found."); reload so it drops out and the default is pre-selected.
          ref.invalidate(addressesProvider);
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, AppSpacing.xl),
        children: [
          const _SectionTitle('Shipping Address'),
          addressesAsync.when(
            loading: () => const _SectionLoading(),
            error:
                (error, _) => _SectionError(
                  message: 'Could not load your addresses: ${extractApiErrorMessage(error)}',
                  onRetry: () => ref.invalidate(addressesProvider),
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
          const _SectionTitle('Order Summary'),
          summaryAsync.when(
            loading: () => const _SectionLoading(),
            error:
                (error, _) => _SectionError(
                  message: 'Could not load your cart: ${extractApiErrorMessage(error)}',
                  onRetry: () => ref.invalidate(checkoutSummaryProvider),
                ),
            data: (summary) => _OrderSummary(summary: summary),
          ),
          const _SectionTitle('Payment'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.payment_outlined, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'You pay on the next step, after you place the order.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          if (checkoutState case CheckoutError(:final message)) ...[
            const SizedBox(height: AppSpacing.lg),
            FormErrorText(message),
          ],
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: ElevatedButton(
          key: const Key('place_order_button'),
          onPressed: canPlaceOrder ? () => ref.read(checkoutProvider.notifier).placeOrder(selectedAddress.id) : null,
          child:
              isSubmitting
                  ? const ButtonProgress()
                  : Text(hasItems || summaryAsync.isLoading ? 'Place Order' : 'Your cart is empty'),
        ),
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
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.md),
      child: Semantics(header: true, child: Text(title.toUpperCase(), style: AppTypography.eyebrow)),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

/// A section that failed to load: what went wrong and a way to try again,
/// without taking over the rest of the checkout.
class _SectionError extends StatelessWidget {
  const _SectionError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormErrorText(message),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
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
          Text('Add a shipping address to continue.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
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
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            // The outline shows which address is chosen as well as the radio.
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: address.id == selected?.id ? AppColors.charcoal : AppColors.border,
                  width: address.id == selected?.id ? 1.5 : 1,
                ),
              ),
              child: RadioListTile<int>(
                key: Key('checkout_address_${address.id}'),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                value: address.id,
                groupValue: selected?.id,
                onChanged: enabled ? (id) => onSelected(id!) : null,
                title: AddressSummary(address: address),
              ),
            ),
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
    final textTheme = Theme.of(context).textTheme;
    if (summary.items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your cart is empty', style: textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Continue Shopping')),
        ],
      );
    }

    return Column(
      children: [
        for (final item in summary.items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.variant.product != null)
                        Text(
                          item.variant.product!.brand.toUpperCase(),
                          style: AppTypography.eyebrow,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 2),
                      Text(item.variant.product?.name ?? 'Product', style: textTheme.bodyLarge),
                      Text(
                        '${item.variant.size} / ${item.variant.color} · '
                        '${item.quantity} × ${formatMoney(item.variant.product?.price ?? 0)}',
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
        const Divider(),
        const SizedBox(height: AppSpacing.sm),
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
