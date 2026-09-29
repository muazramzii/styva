import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/product/pages/product_page.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/cart_item_model.dart';
import 'package:styva_app/models/cart_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/models/variant_model.dart';
import 'package:styva_app/models/wishlist_item_model.dart';
import 'package:styva_app/providers/cart_provider.dart';
import 'package:styva_app/providers/product_provider.dart';
import 'package:styva_app/providers/wishlist_provider.dart';
import 'package:styva_app/services/cart_service.dart';
import 'package:styva_app/services/wishlist_service.dart';

class MockCartService extends Mock implements CartService {}

class MockWishlistService extends Mock implements WishlistService {}

void main() {
  late MockCartService cartService;
  late MockWishlistService wishlistService;

  final product = ProductModel(
    id: 1,
    sku: 'UNQ001',
    name: 'Basic Tee',
    price: 29.90,
    brand: const BrandModel(id: 1, name: 'UNIQLO', slug: 'uniqlo'),
    category: const CategoryModel(id: 2, name: 'Tops', slug: 'tops'),
    variants: const [
      VariantModel(id: 1, size: 'M', color: 'Black', stock: 5),
      VariantModel(id: 2, size: 'L', color: 'Black', stock: 0),
      VariantModel(id: 3, size: 'M', color: 'White', stock: 3),
    ],
  );

  setUp(() {
    cartService = MockCartService();
    wishlistService = MockWishlistService();
  });

  Widget buildTestable() {
    return ProviderScope(
      overrides: [
        productDetailProvider(1).overrideWith((ref) async => product),
        cartServiceProvider.overrideWithValue(cartService),
        wishlistServiceProvider.overrideWithValue(wishlistService),
      ],
      child: const MaterialApp(home: ProductPage(productId: '1')),
    );
  }

  testWidgets('Add to Cart is disabled until a color and size are selected', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Add to Cart'));
    expect(button.onPressed, isNull);
  });

  testWidgets('selecting color then size enables Add to Cart and adds the matching variant',
      (tester) async {
    when(() => cartService.addToCart(variantId: 1, quantity: 1)).thenAnswer(
      (_) async => const CartItemModel(
        id: 1,
        variant: VariantModel(id: 1, size: 'M', color: 'Black', stock: 5),
        quantity: 1,
        subtotal: 29.90,
      ),
    );
    when(() => cartService.getCart()).thenAnswer(
      (_) async => const CartModel(id: 1, items: [], total: 0),
    );

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Black'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'M'));
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Add to Cart'));
    expect(button.onPressed, isNotNull);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
    await tester.pump();
    await tester.pump();

    verify(() => cartService.addToCart(variantId: 1, quantity: 1)).called(1);
  });

  testWidgets('selecting an out-of-stock size disables Add to Cart', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Black'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'L'));
    await tester.pumpAndSettle();

    expect(find.text('Out of stock'), findsOneWidget);
    final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Add to Cart'));
    expect(button.onPressed, isNull);
  });

  testWidgets('Add to Wishlist calls the wishlist service with the product id', (tester) async {
    when(() => wishlistService.addToWishlist(1)).thenAnswer(
      (_) async => WishlistItemModel(id: 1, product: product),
    );
    when(() => wishlistService.getWishlist()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add to Wishlist'));
    await tester.pump();
    await tester.pump();

    verify(() => wishlistService.addToWishlist(1)).called(1);
  });
}
