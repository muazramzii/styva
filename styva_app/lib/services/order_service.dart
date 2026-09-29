import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/order_model.dart';

class OrderService {
  OrderService(this._dio);

  final Dio _dio;

  Future<List<OrderModel>> getOrders() async {
    final response = await _dio.get(ApiConstants.orders);
    final results = response.data['results'] as List;
    return results
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> getOrder(int id) async {
    final response = await _dio.get('${ApiConstants.orders}/$id');
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }
}
