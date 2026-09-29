import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/checkout_request_model.dart';
import '../models/checkout_summary_model.dart';
import '../models/order_model.dart';

/// Errors (400 validation, 401 auth, 409 stock conflict, 5xx) propagate as
/// [DioException] so callers can show them; nothing is swallowed here.
class CheckoutService {
  CheckoutService(this._dio);

  final Dio _dio;

  Future<CheckoutSummaryModel> getSummary() async {
    final response = await _dio.get(ApiConstants.checkout);
    return CheckoutSummaryModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<OrderModel> checkout(CheckoutRequestModel request) async {
    final response = await _dio.post(ApiConstants.checkout, data: request.toJson());
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }
}
