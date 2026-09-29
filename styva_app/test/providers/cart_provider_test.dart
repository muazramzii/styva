import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/cart_item_model.dart';
import 'package:styva_app/models/cart_model.dart';
import 'package:styva_app/models/product_summary_model.dart';
import 'package:styva_app/models/variant_model.dart';
import 'package:styva_app/providers/cart_provider.dart';
import 'package:styva_app/services/cart_service.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  late MockCartService service;
  late ProviderContainer container;

  const variant = VariantModel(
    id: 3,
    size: 'M',
    color: 'Black',
    stock: 10,
    product: ProductSummaryModel(id: 1, name: 'Shirt', price: 89.90, brand: 'UNIQLO'),
  );
  const item = CartItemModel(id: 1, variant: variant, quantity: 2, subtotal: 179.80);
  const emptyCart = CartModel(id: 1, items: [], total: 0.0);
  const cartWithItem = CartModel(id: 1, items: [item], total: 179.80);

  setUp(() {
    service = MockCartService();
    container = ProviderContainer(overrides: [
      cartServiceProvider.overrideWithValue(service),
    ]);
    addTearDown(container.dispose);
  });

  test('starts loading then resolves to the fetched cart', () async {
    when(() => service.getCart()).thenAnswer((_) async => cartWithItem);

    expect(container.read(cartProvider), isA<AsyncLoading>());

    final result = await container.read(cartProvider.future);

    expect(result, cartWithItem);
  });

  test('surfaces an error state when the initial fetch fails', () async {
    when(() => service.getCart()).thenThrow(Exception('network error'));

    await expectLater(container.read(cartProvider.future), throwsException);
    expect(container.read(cartProvider), isA<AsyncError>());
  });

  test('addItem() calls the service then refreshes the cart', () async {
    when(() => service.getCart()).thenAnswer((_) async => emptyCart);
    await container.read(cartProvider.future);

    when(() => service.addToCart(variantId: 3, quantity: 2)).thenAnswer((_) async => item);
    when(() => service.getCart()).thenAnswer((_) async => cartWithItem);

    await container.read(cartProvider.notifier).addItem(variantId: 3, quantity: 2);

    expect(container.read(cartProvider).value, cartWithItem);
  });

  test('addItem() sets an error state and rethrows on stock failure', () async {
    when(() => service.getCart()).thenAnswer((_) async => emptyCart);
    await container.read(cartProvider.future);

    when(() => service.addToCart(variantId: 3, quantity: 99)).thenThrow(Exception('out of stock'));

    await expectLater(
      container.read(cartProvider.notifier).addItem(variantId: 3, quantity: 99),
      throwsException,
    );
    expect(container.read(cartProvider), isA<AsyncError>());
  });

  test('updateItem() calls the service then refreshes the cart', () async {
    when(() => service.getCart()).thenAnswer((_) async => cartWithItem);
    await container.read(cartProvider.future);

    const updatedItem = CartItemModel(id: 1, variant: variant, quantity: 4, subtotal: 359.60);
    const updatedCart = CartModel(id: 1, items: [updatedItem], total: 359.60);
    when(() => service.updateCartItem(itemId: 1, quantity: 4)).thenAnswer((_) async => updatedItem);
    when(() => service.getCart()).thenAnswer((_) async => updatedCart);

    await container.read(cartProvider.notifier).updateItem(itemId: 1, quantity: 4);

    expect(container.read(cartProvider).value, updatedCart);
  });

  test('removeItem() calls the service then refreshes the cart', () async {
    when(() => service.getCart()).thenAnswer((_) async => cartWithItem);
    await container.read(cartProvider.future);

    when(() => service.removeCartItem(1)).thenAnswer((_) async {});
    when(() => service.getCart()).thenAnswer((_) async => emptyCart);

    await container.read(cartProvider.notifier).removeItem(1);

    expect(container.read(cartProvider).value, emptyCart);
  });
}
