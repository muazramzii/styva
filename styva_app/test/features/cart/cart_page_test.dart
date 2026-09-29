import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/cart/pages/cart_page.dart';
import 'package:styva_app/models/cart_item_model.dart';
import 'package:styva_app/models/cart_model.dart';
import 'package:styva_app/models/product_summary_model.dart';
import 'package:styva_app/models/variant_model.dart';
import 'package:styva_app/providers/cart_provider.dart';
import 'package:styva_app/services/cart_service.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  late MockCartService service;

  setUp(() => service = MockCartService());

  Future<void> pumpCart(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/cart',
      routes: [
        GoRoute(path: '/cart', builder: (_, __) => const CartPage()),
        GoRoute(path: '/checkout', builder: (_, __) => const Text('checkout screen')),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [cartServiceProvider.overrideWithValue(service)],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('an empty cart cannot proceed to checkout', (tester) async {
    when(() => service.getCart()).thenAnswer((_) async => const CartModel(id: 1, items: [], total: 0));

    await pumpCart(tester);

    final button = tester.widget<ElevatedButton>(find.byKey(const Key('proceed_to_checkout_button')));
    expect(button.onPressed, isNull);
  });

  testWidgets('a cart with items proceeds to checkout', (tester) async {
    when(() => service.getCart()).thenAnswer((_) async => const CartModel(
          id: 1,
          total: 89.90,
          items: [
            CartItemModel(
              id: 1,
              quantity: 1,
              subtotal: 89.90,
              variant: VariantModel(
                id: 3,
                size: 'M',
                color: 'Black',
                stock: 5,
                product: ProductSummaryModel(id: 1, name: 'Shirt', price: 89.90, brand: 'UNIQLO'),
              ),
            ),
          ],
        ));

    await pumpCart(tester);
    await tester.tap(find.byKey(const Key('proceed_to_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.text('checkout screen'), findsOneWidget);
  });
}
