import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

class CartService {
  CartService(this._dio);

  final Dio _dio;

  Future<CartModel> getCart() async {
    final response = await _dio.get(ApiConstants.cart);
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CartItemModel> addToCart({required int variantId, required int quantity}) async {
    final response = await _dio.post(ApiConstants.cartItems, data: {
      'variant_id': variantId,
      'quantity': quantity,
    });
    return CartItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CartItemModel> updateCartItem({required int itemId, required int quantity}) async {
    final response = await _dio.patch('${ApiConstants.cartItems}/$itemId', data: {
      'quantity': quantity,
    });
    return CartItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> removeCartItem(int itemId) async {
    await _dio.delete('${ApiConstants.cartItems}/$itemId');
  }
}
