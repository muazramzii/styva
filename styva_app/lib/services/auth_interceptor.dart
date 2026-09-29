import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._refreshDio, {this.onSessionExpired});

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  /// Called when a token refresh fails (or there is nothing to refresh with),
  /// so the app can react to the session ending immediately.
  final void Function()? onSessionExpired;

  /// A refresh already in flight, shared by every concurrent 401 so a burst
  /// of requests triggers exactly one refresh call instead of racing each
  /// other (which would otherwise blacklist a still-in-use refresh token).
  Future<String?>? _pendingRefresh;

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
      final newAccess = await _refreshAccessToken();
      if (newAccess != null) {
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccess';
        retryOptions.extra = {...retryOptions.extra, 'retried': true};

        try {
          final retryResponse = await _refreshDio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          // Fall through to propagating the original error below.
        }
      }
    }
    handler.next(err);
  }

  /// Deduplicates concurrent refresh attempts: the first caller performs the
  /// refresh, every other caller awaits the same in-flight future.
  Future<String?> _refreshAccessToken() {
    return _pendingRefresh ??= _performRefresh().whenComplete(() {
      _pendingRefresh = null;
    });
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      return null;
    }
    try {
      final response = await _refreshDio.post(
        ApiConstants.authRefresh,
        data: {'refresh': refreshToken},
      );
      final newAccess = response.data['access'] as String;
      await _tokenStorage.saveAccessToken(newAccess);
      return newAccess;
    } catch (_) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      return null;
    }
  }
}
