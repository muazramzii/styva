import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_model.dart';
import '../services/cart_service.dart';
import 'api_provider.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref.watch(apiClientProvider).dio);
});

class CartNotifier extends AsyncNotifier<CartModel> {
  @override
  Future<CartModel> build() {
    return ref.watch(cartServiceProvider).getCart();
  }

  Future<void> addItem({required int variantId, required int quantity}) async {
    try {
      await ref.read(cartServiceProvider).addToCart(variantId: variantId, quantity: quantity);
      state = AsyncData(await ref.read(cartServiceProvider).getCart());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateItem({required int itemId, required int quantity}) async {
    try {
      await ref.read(cartServiceProvider).updateCartItem(itemId: itemId, quantity: quantity);
      state = AsyncData(await ref.read(cartServiceProvider).getCart());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      await ref.read(cartServiceProvider).removeCartItem(itemId);
      state = AsyncData(await ref.read(cartServiceProvider).getCart());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CartModel>(CartNotifier.new);
