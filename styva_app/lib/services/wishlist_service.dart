import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/wishlist_item_model.dart';

class WishlistService {
  WishlistService(this._dio);

  final Dio _dio;

  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _dio.get(ApiConstants.wishlist);
    final results = response.data['results'] as List;
    return results
        .map((json) => WishlistItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<WishlistItemModel> addToWishlist(int productId) async {
    final response = await _dio.post(ApiConstants.wishlist, data: {
      'product_id': productId,
    });
    return WishlistItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> removeFromWishlist(int productId) async {
    await _dio.delete('${ApiConstants.wishlist}$productId/');
  }
}
