import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/checkout_request_model.dart';
import 'package:styva_app/services/checkout_service.dart';
import 'package:styva_app/services/order_service.dart';

import '../fixtures/order_fixtures.dart';

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

const _request = CheckoutRequestModel(addressId: 7);

void main() {
  late MockDio dio;

  setUpAll(() => registerFallbackValue(RequestOptions(path: '')));
  setUp(() => dio = MockDio());

  group('CheckoutService', () {
    test('checkout posts only the saved address id and parses the created order', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _response(orderDetailJson, statusCode: 201));

      final order = await CheckoutService(dio).checkout(_request);

      expect(order.orderNumber, 'STYVA-20260930-7K3Q9M');
      final body = verify(() => dio.post('/orders/checkout', data: captureAny(named: 'data')))
          .captured
          .single as Map<String, dynamic>;
      expect(body, {'address_id': 7});
    });

    test('getSummary fetches the server-computed preview', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _response({
            'items': [],
            'subtotal': '0.00',
            'shipping_fee': '0.00',
            'total': '0.00',
          }));

      final summary = await CheckoutService(dio).getSummary();

      expect(summary.items, isEmpty);
      verify(() => dio.get('/orders/checkout')).called(1);
    });

    for (final (statusCode, data) in [
      (400, {'detail': 'Your cart is empty.'}),
      (401, {'detail': 'Authentication credentials were not provided.'}),
      (409, {'detail': 'Some items in your cart are no longer available in that quantity.', 'items': []}),
      (500, '<html>Server Error</html>'),
    ]) {
      test('checkout propagates a $statusCode instead of swallowing it', () async {
        when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(_error(statusCode, data));

        await expectLater(
          CheckoutService(dio).checkout(_request),
          throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', statusCode)),
        );
      });
    }
  });

  group('OrderService', () {
    test('getOrders parses the paginated results', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _response({
            'count': 1,
            'results': [orderDetailJson],
          }));

      final orders = await OrderService(dio).getOrders();

      expect(orders.single.orderNumber, 'STYVA-20260930-7K3Q9M');
      verify(() => dio.get('/orders')).called(1);
    });

    test('getOrder fetches a single order by id', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _response(orderDetailJson));

      final order = await OrderService(dio).getOrder(1);

      expect(order.items, hasLength(1));
      verify(() => dio.get('/orders/1')).called(1);
    });

    test('getOrder propagates a 404 for an order the user does not own', () async {
      when(() => dio.get(any())).thenThrow(_error(404, {'detail': 'No Order matches the given query.'}));

      await expectLater(OrderService(dio).getOrder(999), throwsA(isA<DioException>()));
    });
  });
}
