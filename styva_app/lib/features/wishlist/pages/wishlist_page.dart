import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/state_message.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => StateMessage.error(
              title: 'Could not load your wishlist',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(wishlistProvider),
            ),
        data: (items) {
          if (items.isEmpty) {
            return StateMessage(
              icon: Icons.favorite_border,
              title: 'Your wishlist is empty',
              message: 'Save pieces you love and find them here later.',
              actionLabel: 'Discover Products',
              onAction: () => context.go(AppRoutes.home),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(indent: AppSpacing.page, endIndent: AppSpacing.page),
            itemBuilder: (context, index) {
              final product = items[index].product;
              return InkWell(
                onTap: () => context.push('/product/${product.id}'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 76,
                        child: ProductImage(url: product.image, label: product.brand.name, borderRadius: AppRadius.md),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brand.name.toUpperCase(),
                              style: AppTypography.eyebrow,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.name,
                              style: textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(formatMoney(product.price), style: AppTypography.price),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            tooltip: 'Remove from wishlist',
                            onPressed: () async {
                              try {
                                await ref.read(wishlistProvider.notifier).remove(product.id);
                              } catch (e) {
                                if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            tooltip: 'Add to Cart',
                            onPressed:
                                product.variants.isEmpty
                                    ? null
                                    : () async {
                                      try {
                                        await ref
                                            .read(cartProvider.notifier)
                                            .addItem(variantId: product.variants.first.id, quantity: 1);
                                        if (context.mounted) _showMessage(context, 'Added to cart');
                                      } catch (e) {
                                        if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                                      }
                                    },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: wishlistAsync.maybeWhen(
        data:
            (items) =>
                items.isEmpty
                    ? null
                    : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.page,
                          AppSpacing.sm,
                          AppSpacing.page,
                          AppSpacing.lg,
                        ),
                        child: OutlinedButton(
                          onPressed: () => context.push(AppRoutes.cart),
                          child: const Text('Go to Cart'),
                        ),
                      ),
                    ),
        orElse: () => null,
      ),
    );
  }
}
