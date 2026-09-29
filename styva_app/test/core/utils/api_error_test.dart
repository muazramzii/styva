import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/core/utils/api_error.dart';

DioException _error(int statusCode, Object? data) {
  final options = RequestOptions(path: '');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: statusCode, data: data),
    message: 'This exception was thrown because the response has a status code of $statusCode',
  );
}

void main() {
  test('uses the detail message when present (e.g. a 409 stock conflict)', () {
    final message = extractApiErrorMessage(_error(409, {
      'detail': 'Some items in your cart are no longer available in that quantity.',
      'items': [
        {'variant_id': 3, 'requested': 3, 'available': 2},
      ],
    }));

    expect(message, 'Some items in your cart are no longer available in that quantity.');
  });

  test('flattens nested serializer validation errors into readable lines', () {
    final message = extractApiErrorMessage(_error(400, {
      'shipping_address': {
        'postcode': ['Enter a valid 5-digit postcode.'],
        'phone': ['Enter a valid phone number.'],
      },
    }));

    expect(message, 'Enter a valid 5-digit postcode.\nEnter a valid phone number.');
  });

  test('replaces a raw 5xx response with a friendly message', () {
    final message = extractApiErrorMessage(_error(500, '<html>Server Error (500)</html>'));

    expect(message, 'Something went wrong on our side. Please try again.');
  });

  test('reports connection failures clearly', () {
    final message = extractApiErrorMessage(DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.connectionError,
    ));

    expect(message, 'Could not reach the server. Please try again.');
  });
}
