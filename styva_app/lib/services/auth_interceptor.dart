import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._refreshDio);

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthEndpoint = err.requestOptions.path == ApiConstants.authLogin ||
        err.requestOptions.path == ApiConstants.authRegister ||
        err.requestOptions.path == ApiConstants.authRefresh;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (isUnauthorized && !isAuthEndpoint && !alreadyRetried) {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await _refreshDio.post(
            ApiConstants.authRefresh,
            data: {'refresh': refreshToken},
          );
          final newAccess = response.data['access'] as String;
          await _tokenStorage.saveAccessToken(newAccess);

          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccess';
          retryOptions.extra = {...retryOptions.extra, 'retried': true};

          final retryResponse = await _refreshDio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          await _tokenStorage.clear();
        }
      } else {
        await _tokenStorage.clear();
      }
    }
    handler.next(err);
  }
}
