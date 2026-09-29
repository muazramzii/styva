import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/auth_response_model.dart';
import 'package:styva_app/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson parses snake_case fields', () {
      final user = UserModel.fromJson({
        'id': 1,
        'full_name': 'Jane Doe',
        'email': 'jane@example.com',
        'created_at': '2026-01-01T00:00:00Z',
      });

      expect(user.id, 1);
      expect(user.fullName, 'Jane Doe');
      expect(user.email, 'jane@example.com');
      expect(user.createdAt, DateTime.parse('2026-01-01T00:00:00Z'));
    });
  });

  group('AuthResponseModel', () {
    test('fromJson parses tokens and nested user', () {
      final response = AuthResponseModel.fromJson({
        'access': 'access-token',
        'refresh': 'refresh-token',
        'user': {
          'id': 1,
          'full_name': 'Jane Doe',
          'email': 'jane@example.com',
          'created_at': '2026-01-01T00:00:00Z',
        },
      });

      expect(response.access, 'access-token');
      expect(response.refresh, 'refresh-token');
      expect(response.user.email, 'jane@example.com');
    });
  });
}
