import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/api_error.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load wishlist: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your wishlist is empty'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              return ListTile(
                onTap: () => context.go('/product/${product.id}'),
                leading: const Icon(Icons.image_outlined),
                title: Text(product.name),
                subtitle: Text('${product.brand.name} · RM ${product.price.toStringAsFixed(2)}'),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      tooltip: 'Add to Cart',
                      onPressed: product.variants.isEmpty
                          ? null
                          : () async {
                              try {
                                await ref.read(cartProvider.notifier).addItem(
                                      variantId: product.variants.first.id,
                                      quantity: 1,
                                    );
                                if (context.mounted) _showMessage(context, 'Added to cart');
                              } catch (e) {
                                if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                              }
                            },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove',
                      onPressed: () async {
                        try {
                          await ref.read(wishlistProvider.notifier).remove(product.id);
                        } catch (e) {
                          if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () => context.go(AppRoutes.cart),
            child: const Text('Go to Cart'),
          ),
        ),
      ),
    );
  }
}
