import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage storage;
  late TokenStorage tokenStorage;

  setUp(() {
    storage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(storage: storage);
  });

  test('saveTokens writes both access and refresh tokens', () async {
    when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    await tokenStorage.saveTokens(access: 'access-1', refresh: 'refresh-1');

    verify(() => storage.write(key: 'access_token', value: 'access-1')).called(1);
    verify(() => storage.write(key: 'refresh_token', value: 'refresh-1')).called(1);
  });

  test('saveAccessToken only writes the access token', () async {
    when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    await tokenStorage.saveAccessToken('access-2');

    verify(() => storage.write(key: 'access_token', value: 'access-2')).called(1);
    verifyNever(() => storage.write(key: 'refresh_token', value: any(named: 'value')));
  });

  test('getAccessToken reads the access token key', () async {
    when(() => storage.read(key: 'access_token')).thenAnswer((_) async => 'stored-access');

    final result = await tokenStorage.getAccessToken();

    expect(result, 'stored-access');
  });

  test('getRefreshToken reads the refresh token key', () async {
    when(() => storage.read(key: 'refresh_token')).thenAnswer((_) async => 'stored-refresh');

    final result = await tokenStorage.getRefreshToken();

    expect(result, 'stored-refresh');
  });

  test('clear deletes both access and refresh tokens', () async {
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    await tokenStorage.clear();

    verify(() => storage.delete(key: 'access_token')).called(1);
    verify(() => storage.delete(key: 'refresh_token')).called(1);
  });
}
