import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/auth_interceptor.dart';
import 'package:styva_app/services/token_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class MockRefreshDio extends Mock implements Dio {}

DioException _unauthorizedError(String path) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    response: Response(requestOptions: requestOptions, statusCode: 401),
  );
}

/// Runs [AuthInterceptor.onError] in its own error zone.
///
/// In real usage, Dio's pipeline always consumes [ErrorInterceptorHandler]'s
/// completer internally. A standalone handler in a test has nothing else
/// awaiting it, so calling `handler.next(err)` would otherwise surface as an
/// unhandled zone error; `future` itself is `@protected` on the handler, so
/// draining it directly isn't a legitimate option from test code. The handler
/// is created inside the guarded zone (not passed in) so its completer's
/// error-reporting captures *this* zone rather than the outer test zone.
Future<void> _runOnError(AuthInterceptor interceptor, DioException err) {
  final completer = Completer<void>();
  runZonedGuarded(() async {
    final handler = ErrorInterceptorHandler();
    await interceptor.onError(err, handler);
    if (!completer.isCompleted) completer.complete();
  }, (error, stack) {
    if (!completer.isCompleted) completer.complete();
  });
  return completer.future;
}

void main() {
  late MockTokenStorage tokenStorage;
  late MockRefreshDio refreshDio;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    tokenStorage = MockTokenStorage();
    refreshDio = MockRefreshDio();
    interceptor = AuthInterceptor(tokenStorage, refreshDio);

    when(() => tokenStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
  });

  test('a single 401 triggers exactly one refresh call and retries with the new token', () async {
    when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => 'refresh-1');
    when(() => refreshDio.post('/auth/refresh', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        data: {'access': 'new-access'},
        requestOptions: RequestOptions(path: '/auth/refresh'),
        statusCode: 200,
      ),
    );
    when(() => refreshDio.fetch<dynamic>(any())).thenAnswer(
      (_) async => Response(
        data: {'ok': true},
        requestOptions: RequestOptions(path: '/products/'),
        statusCode: 200,
      ),
    );

    await _runOnError(interceptor, _unauthorizedError('/products/'));

    verify(() => refreshDio.post('/auth/refresh', data: {'refresh': 'refresh-1'})).called(1);
    verify(() => tokenStorage.saveAccessToken('new-access')).called(1);
  });

  test('stores the rotated refresh token returned by the backend', () async {
    when(() => tokenStorage.saveTokens(access: any(named: 'access'), refresh: any(named: 'refresh')))
        .thenAnswer((_) async {});
    when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => 'refresh-1');
    when(() => refreshDio.post('/auth/refresh', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        data: {'access': 'new-access', 'refresh': 'refresh-2'},
        requestOptions: RequestOptions(path: '/auth/refresh'),
        statusCode: 200,
      ),
    );
    when(() => refreshDio.fetch<dynamic>(any())).thenAnswer(
      (_) async => Response(
        data: {'ok': true},
        requestOptions: RequestOptions(path: '/products/'),
        statusCode: 200,
      ),
    );

    await _runOnError(interceptor, _unauthorizedError('/products/'));

    verify(() => tokenStorage.saveTokens(access: 'new-access', refresh: 'refresh-2')).called(1);
    verifyNever(() => tokenStorage.saveAccessToken(any()));
  });

  test('concurrent 401s share a single in-flight refresh instead of racing', () async {
    when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => 'refresh-1');

    var refreshCallCount = 0;
    when(() => refreshDio.post('/auth/refresh', data: any(named: 'data'))).thenAnswer((_) async {
      refreshCallCount++;
      // Simulate real network latency so both onError calls land while the
      // first refresh is still in flight.
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return Response(
        data: {'access': 'new-access'},
        requestOptions: RequestOptions(path: '/auth/refresh'),
        statusCode: 200,
      );
    });
    when(() => refreshDio.fetch<dynamic>(any())).thenAnswer(
      (_) async => Response(
        data: {'ok': true},
        requestOptions: RequestOptions(path: '/products/'),
        statusCode: 200,
      ),
    );

    await Future.wait([
      _runOnError(interceptor, _unauthorizedError('/products/')),
      _runOnError(interceptor, _unauthorizedError('/orders/')),
    ]);

    expect(refreshCallCount, 1, reason: 'only one refresh call should ever be made for concurrent 401s');
    verify(() => tokenStorage.saveAccessToken('new-access')).called(1);
  });

  test('clears storage and reports session expiry when there is no refresh token', () async {
    when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => null);
    var sessionExpiredCalled = false;
    interceptor = AuthInterceptor(
      tokenStorage,
      refreshDio,
      onSessionExpired: () => sessionExpiredCalled = true,
    );

    await _runOnError(interceptor, _unauthorizedError('/products/'));

    verify(() => tokenStorage.clear()).called(1);
    expect(sessionExpiredCalled, isTrue);
    verifyNever(() => refreshDio.post(any(), data: any(named: 'data')));
  });

  test('does not attempt to refresh a 401 from the login endpoint itself', () async {
    await _runOnError(interceptor, _unauthorizedError('/auth/login'));

    verifyNever(() => tokenStorage.getRefreshToken());
    verifyNever(() => refreshDio.post(any(), data: any(named: 'data')));
  });

  test('does not retry a request that has already been retried once', () async {
    final requestOptions = RequestOptions(path: '/products/', extra: {'retried': true});
    final err = DioException(
      requestOptions: requestOptions,
      response: Response(requestOptions: requestOptions, statusCode: 401),
    );

    await _runOnError(interceptor, err);

    verifyNever(() => tokenStorage.getRefreshToken());
  });
}
