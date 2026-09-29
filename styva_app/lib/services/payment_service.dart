import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/payment_model.dart';

class PaymentService {
  PaymentService(this._dio);

  final Dio _dio;

  /// Starts (or resumes) payment for an order. Only the order id is sent --
  /// the backend takes the amount from the order itself.
  Future<PaymentModel> initiatePayment(int orderId) async {
    final response = await _dio.post(ApiConstants.paymentsInitiate, data: {'order_id': orderId});
    return PaymentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PaymentModel> getPayment(int id) async {
    final response = await _dio.get('${ApiConstants.payments}/$id');
    return PaymentModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DEVELOPMENT ONLY: asks the backend's mock provider to report [outcome]
  /// (`success` or `failed`). The backend rejects this outside development.
  Future<PaymentModel> simulateMockPayment(int id, String outcome) async {
    final response = await _dio.post(
      '${ApiConstants.payments}/$id/mock-complete',
      data: {'outcome': outcome},
    );
    return PaymentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
