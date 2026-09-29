import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient(TokenStorage tokenStorage) {
    final refreshDio = Dio(_baseOptions());
    _dio = Dio(_baseOptions())
      ..interceptors.add(AuthInterceptor(tokenStorage, refreshDio));
  }

  late final Dio _dio;

  Dio get dio => _dio;

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
