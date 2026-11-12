import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/address_model.dart';
import 'package:styva_app/services/address_service.dart';
import 'package:styva_app/services/auth_service.dart';

import '../fixtures/address_fixtures.dart';

class MockDio extends Mock implements Dio {}

Response<T> _response<T>(T data, {int statusCode = 200}) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: statusCode);
}

DioException _error(int statusCode, Object? data) {
  final options = RequestOptions(path: '');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: statusCode, data: data),
  );
}

const _input = AddressInput(
  recipientName: 'Ali Bin Abu',
  phone: '0198765432',
  addressLine1: '123 Jalan ABC',
  city: 'Skudai',
  state: 'Johor',
  postcode: '81300',
);

void main() {
  late MockDio dio;

  setUp(() => dio = MockDio());

  group('AuthService profile', () {
    test('updateProfile patches only name and phone on /auth/me', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer((_) async => _response({
            'id': 1,
            'full_name': 'New Name',
            'email': 'jane@example.com',
            'phone': '0123456789',
            'created_at': '2026-09-30T10:00:00Z',
          }));

      final user = await AuthService(dio).updateProfile(fullName: 'New Name', phone: '0123456789');

      final body = verify(() => dio.patch('/auth/me', data: captureAny(named: 'data'))).captured.single;
      expect(body, {'full_name': 'New Name', 'phone': '0123456789'});
      expect(user.fullName, 'New Name');
    });

    test('changePassword posts the three fields and returns the new tokens', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _response({'access': 'a-2', 'refresh': 'r-2'}));

      final tokens = await AuthService(dio).changePassword(
        currentPassword: 'OldPass123!',
        newPassword: 'NewPass456!',
        confirmNewPassword: 'NewPass456!',
      );

      final body =
          verify(() => dio.post('/auth/change-password', data: captureAny(named: 'data'))).captured.single;
      expect(body, {
        'current_password': 'OldPass123!',
        'new_password': 'NewPass456!',
        'confirm_new_password': 'NewPass456!',
      });
      expect(tokens.access, 'a-2');
      expect(tokens.refresh, 'r-2');
    });

    test('changePassword propagates validation errors', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(_error(400, {
        'current_password': ['Current password is incorrect.'],
      }));

      expect(
        () => AuthService(dio).changePassword(currentPassword: 'x', newPassword: 'y', confirmNewPassword: 'y'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('AddressService', () {
    test('getAddresses parses the list', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _response([addressJson(id: 1), addressJson(id: 2, isDefault: false)]),
      );

      final addresses = await AddressService(dio).getAddresses();

      verify(() => dio.get('/addresses')).called(1);
      expect(addresses.map((a) => a.id), [1, 2]);
    });

    test('createAddress posts the input', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _response(addressJson(id: 9), statusCode: 201));

      final created = await AddressService(dio).createAddress(_input);

      final body = verify(() => dio.post('/addresses', data: captureAny(named: 'data'))).captured.single;
      expect(body, _input.toJson());
      expect(created.id, 9);
    });

    test('updateAddress patches the address by id', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer((_) async => _response(addressJson(id: 9)));

      await AddressService(dio).updateAddress(9, _input);

      final body = verify(() => dio.patch('/addresses/9', data: captureAny(named: 'data'))).captured.single;
      expect(body, _input.toJson());
    });

    test('setDefault sends only is_default', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer((_) async => _response(addressJson(id: 9)));

      await AddressService(dio).setDefault(9);

      final body = verify(() => dio.patch('/addresses/9', data: captureAny(named: 'data'))).captured.single;
      expect(body, {'is_default': true});
    });

    test('deleteAddress deletes by id', () async {
      when(() => dio.delete(any())).thenAnswer((_) async => _response(null, statusCode: 204));

      await AddressService(dio).deleteAddress(9);

      verify(() => dio.delete('/addresses/9')).called(1);
    });

    test('a 404 for an address that is not yours propagates', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenThrow(_error(404, {'detail': 'Not found.'}));

      expect(() => AddressService(dio).setDefault(99), throwsA(isA<DioException>()));
    });
  });
}
