import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/api_error.dart';
import '../../../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load cart: $error')),
        data: (cart) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final product = item.variant.product;
              return ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text(product?.name ?? 'Product'),
                subtitle: Text(
                  '${item.variant.size} / ${item.variant.color} · Qty ${item.quantity}\n'
                  'RM ${item.subtotal.toStringAsFixed(2)}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: item.quantity <= 1
                          ? null
                          : () async {
                              try {
                                await ref.read(cartProvider.notifier).updateItem(
                                      itemId: item.id,
                                      quantity: item.quantity - 1,
                                    );
                              } catch (e) {
                                if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                              }
                            },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: item.quantity >= item.variant.stock
                          ? null
                          : () async {
                              try {
                                await ref.read(cartProvider.notifier).updateItem(
                                      itemId: item.id,
                                      quantity: item.quantity + 1,
                                    );
                              } catch (e) {
                                if (context.mounted) _showMessage(context, extractApiErrorMessage(e));
                              }
                            },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        try {
                          await ref.read(cartProvider.notifier).removeItem(item.id);
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
      bottomNavigationBar: cartAsync.maybeWhen(
        data: (cart) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    Text('RM ${cart.total.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 12),
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
        orElse: () => null,
      ),
    );
  }
}
