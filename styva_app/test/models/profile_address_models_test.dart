import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/address_model.dart';
import 'package:styva_app/models/user_model.dart';

import '../fixtures/address_fixtures.dart';

void main() {
  group('UserModel', () {
    test('parses phone', () {
      final user = UserModel.fromJson({
        'id': 1,
        'full_name': 'Jane Doe',
        'email': 'jane@example.com',
        'phone': '0123456789',
        'created_at': '2026-09-30T10:00:00Z',
      });

      expect(user.phone, '0123456789');
    });

    test('phone defaults to empty for accounts without one', () {
      final user = UserModel.fromJson({
        'id': 1,
        'full_name': 'Jane Doe',
        'email': 'jane@example.com',
        'created_at': '2026-09-30T10:00:00Z',
      });

      expect(user.phone, '');
    });
  });

  group('AddressModel', () {
    test('parses the backend address payload', () {
      final address = AddressModel.fromJson(addressJson(id: 4, isDefault: true));

      expect(address.id, 4);
      expect(address.recipientName, 'Ali Bin Abu');
      expect(address.phone, '0198765432');
      expect(address.addressLine1, '123 Jalan ABC');
      expect(address.addressLine2, 'Taman Lama');
      expect(address.city, 'Skudai');
      expect(address.state, 'Johor');
      expect(address.postcode, '81300');
      expect(address.country, 'Malaysia');
      expect(address.isDefault, isTrue);
    });

    test('keeps postcodes with a leading zero as text', () {
      final address = AddressModel.fromJson(addressJson(postcode: '01000'));
      expect(address.postcode, '01000');
    });
  });

  group('AddressInput', () {
    test('toJson sends only writable fields in snake_case', () {
      const input = AddressInput(
        recipientName: 'Ali Bin Abu',
        phone: '0198765432',
        addressLine1: '123 Jalan ABC',
        city: 'Skudai',
        state: 'Johor',
        postcode: '81300',
        isDefault: true,
      );

      expect(input.toJson(), {
        'recipient_name': 'Ali Bin Abu',
        'phone': '0198765432',
        'address_line_1': '123 Jalan ABC',
        'address_line_2': '',
        'city': 'Skudai',
        'state': 'Johor',
        'postcode': '81300',
        'country': 'Malaysia',
        'is_default': true,
      });
    });
  });
}
