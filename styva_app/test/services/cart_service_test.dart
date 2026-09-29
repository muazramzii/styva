import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/cart_service.dart';

class MockDio extends Mock implements Dio {}

const _variantJson = {
  'id': 3,
  'size': 'M',
  'color': 'Black',
  'stock': 10,
  'product': {'id': 1, 'name': 'Shirt', 'price': '89.90', 'brand': 'UNIQLO'},
};

Response<T> _jsonResponse<T>(T data, {int statusCode = 200}) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: statusCode);
}

void main() {
  late MockDio dio;
  late CartService service;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    dio = MockDio();
    service = CartService(dio);
  });

  test('getCart parses the cart with items and total', () async {
    when(() => dio.get(any())).thenAnswer(
      (_) async => _jsonResponse({
        'id': 1,
        'items': [
          {'id': 1, 'variant': _variantJson, 'quantity': 2, 'subtotal': '179.80'},
        ],
        'total': '179.80',
      }),
    );

    final cart = await service.getCart();

    expect(cart.items, hasLength(1));
    expect(cart.total, 179.80);
    verify(() => dio.get('/cart')).called(1);
  });

  test('addToCart posts variant_id/quantity and parses the created item', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse(
        {'id': 1, 'variant': _variantJson, 'quantity': 2, 'subtotal': '179.80'},
        statusCode: 201,
      ),
    );

    final item = await service.addToCart(variantId: 3, quantity: 2);

    expect(item.quantity, 2);
    final captured = verify(() => dio.post('/cart/items', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {'variant_id': 3, 'quantity': 2});
  });

  test('addToCart propagates a stock validation error instead of swallowing it', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'quantity': ['Only 5 in stock.']},
        ),
      ),
    );

    expect(() => service.addToCart(variantId: 3, quantity: 99), throwsA(isA<DioException>()));
  });

  test('updateCartItem patches quantity and parses the updated item', () async {
    when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse({'id': 1, 'variant': _variantJson, 'quantity': 4, 'subtotal': '359.60'}),
    );

    final item = await service.updateCartItem(itemId: 1, quantity: 4);

    expect(item.quantity, 4);
    final captured = verify(() => dio.patch('/cart/items/1', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {'quantity': 4});
  });

  test('removeCartItem deletes by item id', () async {
    when(() => dio.delete(any())).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204),
    );

    await service.removeCartItem(1);

    verify(() => dio.delete('/cart/items/1')).called(1);
  });
}
