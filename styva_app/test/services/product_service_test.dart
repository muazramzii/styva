import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/product_service.dart';

class MockDio extends Mock implements Dio {}

Response<T> _jsonResponse<T>(T data) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: 200);
}

void main() {
  late MockDio dio;
  late ProductService service;

  setUp(() {
    dio = MockDio();
    service = ProductService(dio);
  });

  group('getProducts', () {
    test('parses the paginated results list into ProductModel objects', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => _jsonResponse({
          'count': 1,
          'next': null,
          'previous': null,
          'results': [
            {
              'id': 1,
              'sku': 'UNQ001',
              'name': 'Basic Tee',
              'description': 'A tee.',
              'price': '29.90',
              'image': null,
              'brand': {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
              'category': {'id': 1, 'name': 'Tops', 'slug': 'tops'},
              'variants': [],
            },
          ],
        }),
      );

      final products = await service.getProducts();

      expect(products, hasLength(1));
      expect(products.first.name, 'Basic Tee');
      expect(products.first.price, 29.90);
    });

    test('forwards the page parameter so results beyond the first page are reachable', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => _jsonResponse({'count': 0, 'next': null, 'previous': null, 'results': []}),
      );

      await service.getProducts(page: 2);

      final captured = verify(() => dio.get(captureAny(), queryParameters: captureAny(named: 'queryParameters'))).captured;
      expect(captured[1], {'page': 2});
    });

    test('forwards filter parameters as query parameters', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => _jsonResponse({'count': 0, 'next': null, 'previous': null, 'results': []}),
      );

      await service.getProducts(brand: 'uniqlo', category: 'tops', minPrice: 10, maxPrice: 100, search: 'tee', ordering: 'price_low');

      final captured = verify(() => dio.get(captureAny(), queryParameters: captureAny(named: 'queryParameters'))).captured;
      expect(captured[0], '/products/');
      expect(captured[1], {
        'brand': 'uniqlo',
        'category': 'tops',
        'min_price': 10.0,
        'max_price': 100.0,
        'search': 'tee',
        'ordering': 'price_low',
      });
    });
  });

  group('getProduct', () {
    test('parses a single product by id', () async {
      when(() => dio.get('/products/1/')).thenAnswer(
        (_) async => _jsonResponse({
          'id': 1,
          'sku': 'UNQ001',
          'name': 'Basic Tee',
          'description': 'A tee.',
          'price': '29.90',
          'image': null,
          'brand': {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
          'category': {'id': 1, 'name': 'Tops', 'slug': 'tops'},
          'variants': [
            {'id': 1, 'size': 'M', 'color': 'White', 'stock': 10},
          ],
        }),
      );

      final product = await service.getProduct(1);

      expect(product.id, 1);
      expect(product.variants, hasLength(1));
    });
  });

  group('getBrands', () {
    test('parses the brand results list', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _jsonResponse({
          'count': 1,
          'results': [
            {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
          ],
        }),
      );

      final brands = await service.getBrands();

      expect(brands, hasLength(1));
      expect(brands.first.name, 'UNIQLO');
    });
  });

  group('getCategories', () {
    test('parses the category results list', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _jsonResponse({
          'count': 1,
          'results': [
            {'id': 1, 'name': 'Tops', 'slug': 'tops'},
          ],
        }),
      );

      final categories = await service.getCategories();

      expect(categories, hasLength(1));
      expect(categories.first.name, 'Tops');
    });
  });
}
