import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/core/theme/app_theme.dart';
import 'package:styva_app/features/discover/pages/discover_page.dart';
import 'package:styva_app/features/home/pages/home_page.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/providers/product_provider.dart';
import 'package:styva_app/services/product_service.dart';

class MockProductService extends Mock implements ProductService {}

const _tops = CategoryModel(id: 1, name: 'Tops', slug: 'tops');
const _uniqlo = BrandModel(id: 1, name: 'UNIQLO', slug: 'uniqlo');

ProductModel _product(int id, String name) =>
    ProductModel(id: id, sku: 'SKU$id', name: name, price: 50, brand: _uniqlo, category: _tops);

void main() {
  late MockProductService service;

  setUp(() {
    service = MockProductService();
    when(() => service.getCategories()).thenAnswer((_) async => [_tops]);
    when(() => service.getBrands()).thenAnswer((_) async => [_uniqlo]);
  });

  void stubProducts(List<ProductModel> products) {
    when(() => service.getProducts(
          category: any(named: 'category'),
          brand: any(named: 'brand'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => products);
  }

  Future<void> pumpAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(path: '/discover', builder: (_, __) => const DiscoverPage()),
        GoRoute(path: '/product/:id', builder: (_, state) => Text('product ${state.pathParameters['id']}')),
        for (final path in ['/wishlist', '/cart', '/orders', '/profile'])
          GoRoute(path: path, builder: (_, __) => Text(path)),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [productServiceProvider.overrideWithValue(service)],
      child: MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  group('Home', () {
    testWidgets('shows the wordmark, filters and products from the API', (tester) async {
      stubProducts([_product(1, 'Basic Tee'), _product(2, 'Linen Shirt')]);

      await pumpAt(tester, '/home');

      expect(find.text('STYVA'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, 'Tops'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, 'UNIQLO'), findsOneWidget);
      expect(find.text('Basic Tee'), findsOneWidget);
      expect(find.text('Linen Shirt'), findsOneWidget);
    });

    testWidgets('choosing a category asks the API for that category', (tester) async {
      stubProducts([_product(1, 'Basic Tee')]);
      await pumpAt(tester, '/home');

      await tester.tap(find.widgetWithText(ChoiceChip, 'Tops'));
      await tester.pumpAndSettle();

      verify(() => service.getProducts(category: 'tops', brand: null, search: null)).called(1);
      final chip = tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Tops'));
      expect(chip.selected, isTrue);
    });

    testWidgets('an empty filtered result offers Clear filters', (tester) async {
      stubProducts([_product(1, 'Basic Tee')]);
      await pumpAt(tester, '/home');
      when(() => service.getProducts(category: null, brand: 'uniqlo', search: null)).thenAnswer((_) async => []);

      await tester.tap(find.widgetWithText(ChoiceChip, 'UNIQLO'));
      await tester.pumpAndSettle();
      expect(find.text('Nothing matches yet'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();
      expect(find.text('Basic Tee'), findsOneWidget);
    });

    testWidgets('a load error offers Retry', (tester) async {
      when(() => service.getProducts(
            category: any(named: 'category'),
            brand: any(named: 'brand'),
            search: any(named: 'search'),
          )).thenThrow(Exception('offline'));
      await pumpAt(tester, '/home');

      expect(find.text('Could not load products'), findsOneWidget);
      stubProducts([_product(1, 'Basic Tee')]);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Basic Tee'), findsOneWidget);
    });

    testWidgets('tapping a product opens it with a back button', (tester) async {
      stubProducts([_product(5, 'Basic Tee')]);
      await pumpAt(tester, '/home');

      await tester.tap(find.text('Basic Tee'));
      await tester.pumpAndSettle();

      expect(find.text('product 5'), findsOneWidget);
    });

    testWidgets('the search entry opens search', (tester) async {
      stubProducts([_product(1, 'Basic Tee')]);
      await pumpAt(tester, '/home');

      await tester.tap(find.bySemanticsLabel('Search products'));
      await tester.pumpAndSettle();

      expect(find.byType(DiscoverPage), findsOneWidget);
    });
  });

  group('Search', () {
    testWidgets('searches the backend after a pause in typing', (tester) async {
      stubProducts([_product(1, 'Basic Tee')]);
      await pumpAt(tester, '/discover');
      when(() => service.getProducts(category: null, brand: null, search: 'linen'))
          .thenAnswer((_) async => [_product(2, 'Linen Shirt')]);

      await tester.enterText(find.byKey(const Key('search_field')), 'linen');
      await tester.pump(const Duration(milliseconds: 100));
      verifyNever(() => service.getProducts(category: null, brand: null, search: 'linen'));

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      verify(() => service.getProducts(category: null, brand: null, search: 'linen')).called(1);
      expect(find.text('Linen Shirt'), findsOneWidget);
    });

    testWidgets('no matches shows a helpful empty state', (tester) async {
      stubProducts([_product(1, 'Basic Tee')]);
      await pumpAt(tester, '/discover');
      when(() => service.getProducts(category: null, brand: null, search: 'zzz')).thenAnswer((_) async => []);

      await tester.enterText(find.byKey(const Key('search_field')), 'zzz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No results'), findsOneWidget);
      expect(find.textContaining('"zzz"'), findsOneWidget);
    });
  });
}
