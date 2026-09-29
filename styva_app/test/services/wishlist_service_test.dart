import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/wishlist_service.dart';

class MockDio extends Mock implements Dio {}

const _productJson = {
  'id': 10,
  'sku': 'UNQ001',
  'name': 'Basic Tee',
  'description': 'A tee.',
  'price': '29.90',
  'image': null,
  'brand': {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
  'category': {'id': 2, 'name': 'Tops', 'slug': 'tops'},
  'variants': [],
};

Response<T> _jsonResponse<T>(T data, {int statusCode = 200}) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: statusCode);
}

void main() {
  late MockDio dio;
  late WishlistService service;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    dio = MockDio();
    service = WishlistService(dio);
  });

  test('getWishlist parses the paginated results into WishlistItemModel objects', () async {
    when(() => dio.get(any())).thenAnswer(
      (_) async => _jsonResponse({
        'count': 1,
        'results': [
          {'id': 1, 'product': _productJson, 'created_at': '2026-01-01T00:00:00Z'},
        ],
      }),
    );

    final items = await service.getWishlist();

    expect(items, hasLength(1));
    expect(items.first.product.name, 'Basic Tee');
    verify(() => dio.get('/wishlist/')).called(1);
  });

  test('addToWishlist posts product_id and parses the created item', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => _jsonResponse(
        {'id': 1, 'product': _productJson, 'created_at': '2026-01-01T00:00:00Z'},
        statusCode: 201,
      ),
    );

    final item = await service.addToWishlist(10);

    expect(item.product.id, 10);
    final captured = verify(() => dio.post('/wishlist/', data: captureAny(named: 'data'))).captured;
    expect(captured.single, {'product_id': 10});
  });

  test('addToWishlist propagates the error instead of swallowing it', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'product_id': ['This product is already in your wishlist.']},
        ),
      ),
    );

    expect(() => service.addToWishlist(10), throwsA(isA<DioException>()));
  });

  test('removeFromWishlist deletes by product id', () async {
    when(() => dio.delete(any())).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 204),
    );

    await service.removeFromWishlist(10);

    verify(() => dio.delete('/wishlist/10/')).called(1);
  });
}
