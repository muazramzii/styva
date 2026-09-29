import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wishlist_item_model.dart';
import '../services/wishlist_service.dart';
import 'api_provider.dart';

final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService(ref.watch(apiClientProvider).dio);
});

class WishlistNotifier extends AsyncNotifier<List<WishlistItemModel>> {
  @override
  Future<List<WishlistItemModel>> build() {
    return ref.watch(wishlistServiceProvider).getWishlist();
  }

  Future<void> add(int productId) async {
    try {
      await ref.read(wishlistServiceProvider).addToWishlist(productId);
      state = AsyncData(await ref.read(wishlistServiceProvider).getWishlist());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> remove(int productId) async {
    try {
      await ref.read(wishlistServiceProvider).removeFromWishlist(productId);
      state = AsyncData(await ref.read(wishlistServiceProvider).getWishlist());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<WishlistItemModel>>(
  WishlistNotifier.new,
);
