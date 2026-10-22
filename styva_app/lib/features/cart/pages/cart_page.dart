import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/state_message.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Runs a cart change and reports any API error as a snack bar.
  Future<void> _change(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => StateMessage.error(
              title: 'Could not load your cart',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(cartProvider),
            ),
        data: (cart) {
          if (cart.items.isEmpty) {
            return StateMessage(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Pieces you add will appear here.',
              actionLabel: 'Continue Shopping',
              onAction: () => context.go(AppRoutes.home),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const Divider(indent: AppSpacing.page, endIndent: AppSpacing.page),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _CartItemRow(
                item: item,
                onDecrease:
                    item.quantity <= 1
                        ? null
                        : () =>
                            _change(context, () => notifier.updateItem(itemId: item.id, quantity: item.quantity - 1)),
                onIncrease:
                    item.quantity >= item.variant.stock
                        ? null
                        : () =>
                            _change(context, () => notifier.updateItem(itemId: item.id, quantity: item.quantity + 1)),
                onRemove: () => _change(context, () => notifier.removeItem(item.id)),
              );
            },
          );
        },
      ),
      bottomNavigationBar: cartAsync.maybeWhen(
        data:
            (cart) => DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cart.items.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: Theme.of(context).textTheme.titleMedium),
                            Text(formatMoney(cart.total), style: AppTypography.price.copyWith(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('proceed_to_checkout_button'),
                          onPressed: cart.items.isEmpty ? null : () => context.go(AppRoutes.checkout),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        orElse: () => null,
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.item, required this.onDecrease, required this.onIncrease, required this.onRemove});

  final CartItemModel item;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final product = item.variant.product;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 76, child: ProductImage(url: null, label: product?.brand, borderRadius: AppRadius.md)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product != null)
                  Text(
                    product.brand.toUpperCase(),
                    style: AppTypography.eyebrow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  product?.name ?? 'Product',
                  style: textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('${item.variant.size} / ${item.variant.color}', style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Decrease quantity',
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: onDecrease,
                        ),
                        Text(
                          '${item.quantity}',
                          style: textTheme.titleSmall,
                          semanticsLabel: 'Quantity ${item.quantity}',
                        ),
                        IconButton(
                          tooltip: 'Increase quantity',
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: onIncrease,
                        ),
                      ],
                    ),
                    Text(formatMoney(item.subtotal), style: AppTypography.price),
                  ],
                ),
              ],
            ),
          ),
          IconButton(tooltip: 'Remove from cart', icon: const Icon(Icons.close, size: 20), onPressed: onRemove),
        ],
      ),
    );
  }
}
