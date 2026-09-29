import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/auth_service.dart';

class MockDio extends Mock implements Dio {}

Response<T> _jsonResponse<T>(T data) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: 200);
}

const _userJson = {
  'id': 1,
  'full_name': 'Jane Doe',
  'email': 'jane@example.com',
  'created_at': '2026-01-01T00:00:00Z',
};

void main() {
  late MockDio dio;
  late AuthService service;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    dio = MockDio();
    service = AuthService(dio);
  });

  test('register posts full_name/email/password and parses the response', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse({'access': 'a', 'refresh': 'r', 'user': _userJson}),
    );

    final result = await service.register(
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      password: 'StrongPass123!',
    );

    expect(result.access, 'a');
    expect(result.user.fullName, 'Jane Doe');
    final captured = verify(() => dio.post('/auth/register', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {
      'full_name': 'Jane Doe',
      'email': 'jane@example.com',
      'password': 'StrongPass123!',
    });
  });

  test('login posts email/password and parses the response', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse({'access': 'a', 'refresh': 'r', 'user': _userJson}),
    );

    final result = await service.login(email: 'jane@example.com', password: 'StrongPass123!');

    expect(result.access, 'a');
    expect(result.refresh, 'r');
  });

  test('refresh posts the refresh token and returns the new access token', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse({'access': 'new-access'}),
    );

    final access = await service.refresh('old-refresh');

    expect(access, 'new-access');
    final captured = verify(() => dio.post('/auth/refresh', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {'refresh': 'old-refresh'});
  });

  test('me fetches and parses the current user', () async {
    when(() => dio.get(any())).thenAnswer((_) async => _jsonResponse(_userJson));

    final user = await service.me();

    expect(user.email, 'jane@example.com');
    verify(() => dio.get('/auth/me')).called(1);
  });

  test('logout posts the refresh token to the logout endpoint', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 205),
    );

    await service.logout('some-refresh');

    final captured = verify(() => dio.post('/auth/logout', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {'refresh': 'some-refresh'});
  });
}
