import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/wishlist/pages/wishlist_page.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/models/variant_model.dart';
import 'package:styva_app/models/wishlist_item_model.dart';
import 'package:styva_app/providers/cart_provider.dart';
import 'package:styva_app/providers/wishlist_provider.dart';
import 'package:styva_app/services/cart_service.dart';
import 'package:styva_app/services/wishlist_service.dart';

class MockWishlistService extends Mock implements WishlistService {}

class MockCartService extends Mock implements CartService {}

const _item = WishlistItemModel(
  id: 10,
  product: ProductModel(
    id: 1,
    sku: 'UNQ001',
    name: 'Oversized Cotton Shirt',
    price: 89.90,
    brand: BrandModel(id: 1, name: 'UNIQLO', slug: 'uniqlo'),
    category: CategoryModel(id: 1, name: 'Tops', slug: 'tops'),
    variants: [
      VariantModel(id: 3, size: 'M', color: 'Black', stock: 5),
      VariantModel(id: 4, size: 'L', color: 'White', stock: 0),
    ],
  ),
);

void main() {
  late MockWishlistService wishlistService;
  late MockCartService cartService;

  setUp(() {
    wishlistService = MockWishlistService();
    cartService = MockCartService();
  });

  Future<void> pumpWishlist(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/wishlist',
      routes: [
        GoRoute(path: '/wishlist', builder: (_, __) => const WishlistPage()),
        GoRoute(path: '/product/:id', builder: (_, state) => Text('product ${state.pathParameters['id']}')),
        GoRoute(path: '/home', builder: (_, __) => const Text('home')),
        GoRoute(path: '/cart', builder: (_, __) => const Text('cart')),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        wishlistServiceProvider.overrideWithValue(wishlistService),
        cartServiceProvider.overrideWithValue(cartService),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shows saved products with brand and price', (tester) async {
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => [_item]);

    await pumpWishlist(tester);

    expect(find.text('UNIQLO'), findsOneWidget);
    expect(find.text('Oversized Cotton Shirt'), findsOneWidget);
    expect(find.text('RM 89.90'), findsOneWidget);
  });

  testWidgets('Choose size opens the product instead of guessing a variant', (tester) async {
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => [_item]);
    await pumpWishlist(tester);

    await tester.tap(find.text('Choose size'));
    await tester.pumpAndSettle();

    expect(find.text('product 1'), findsOneWidget);
    verifyNever(() => cartService.addToCart(variantId: any(named: 'variantId'), quantity: any(named: 'quantity')));
  });

  testWidgets('removing an item calls the wishlist service', (tester) async {
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => [_item]);
    when(() => wishlistService.removeFromWishlist(1)).thenAnswer((_) async {});
    await pumpWishlist(tester);

    when(() => wishlistService.getWishlist()).thenAnswer((_) async => []);
    await tester.tap(find.byTooltip('Remove from wishlist'));
    await tester.pumpAndSettle();

    verify(() => wishlistService.removeFromWishlist(1)).called(1);
    expect(find.text('Your wishlist is empty'), findsOneWidget);
  });

  testWidgets('empty wishlist offers a way back to shopping', (tester) async {
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => []);
    await pumpWishlist(tester);

    await tester.tap(find.text('Discover Products'));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('a load error offers Retry', (tester) async {
    when(() => wishlistService.getWishlist()).thenThrow(Exception('offline'));
    await pumpWishlist(tester);

    expect(find.text('Could not load your wishlist'), findsOneWidget);
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => [_item]);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Oversized Cotton Shirt'), findsOneWidget);
  });
}
