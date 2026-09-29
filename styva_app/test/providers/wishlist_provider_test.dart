import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/models/wishlist_item_model.dart';
import 'package:styva_app/providers/wishlist_provider.dart';
import 'package:styva_app/services/wishlist_service.dart';

class MockWishlistService extends Mock implements WishlistService {}

void main() {
  late MockWishlistService service;
  late ProviderContainer container;

  final product = ProductModel(
    id: 10,
    sku: 'UNQ001',
    name: 'Basic Tee',
    price: 29.90,
    brand: const BrandModel(id: 1, name: 'UNIQLO', slug: 'uniqlo'),
    category: const CategoryModel(id: 2, name: 'Tops', slug: 'tops'),
  );
  final item = WishlistItemModel(id: 1, product: product);

  setUp(() {
    service = MockWishlistService();
    container = ProviderContainer(overrides: [
      wishlistServiceProvider.overrideWithValue(service),
    ]);
    addTearDown(container.dispose);
  });

  test('starts loading then resolves to the fetched list', () async {
    when(() => service.getWishlist()).thenAnswer((_) async => [item]);

    final asyncBeforeLoad = container.read(wishlistProvider);
    expect(asyncBeforeLoad, isA<AsyncLoading>());

    final result = await container.read(wishlistProvider.future);

    expect(result, [item]);
    expect(container.read(wishlistProvider).value, [item]);
  });

  test('surfaces an error state when the initial fetch fails', () async {
    when(() => service.getWishlist()).thenThrow(Exception('network error'));

    await expectLater(container.read(wishlistProvider.future), throwsException);
    expect(container.read(wishlistProvider), isA<AsyncError>());
  });

  test('add() calls the service then refreshes the list', () async {
    when(() => service.getWishlist()).thenAnswer((_) async => []);
    await container.read(wishlistProvider.future);

    when(() => service.addToWishlist(10)).thenAnswer((_) async => item);
    when(() => service.getWishlist()).thenAnswer((_) async => [item]);

    await container.read(wishlistProvider.notifier).add(10);

    expect(container.read(wishlistProvider).value, [item]);
  });

  test('add() sets an error state and rethrows when the service call fails', () async {
    when(() => service.getWishlist()).thenAnswer((_) async => []);
    await container.read(wishlistProvider.future);

    when(() => service.addToWishlist(10)).thenThrow(Exception('duplicate'));

    await expectLater(
      container.read(wishlistProvider.notifier).add(10),
      throwsException,
    );
    expect(container.read(wishlistProvider), isA<AsyncError>());
  });

  test('remove() calls the service then refreshes the list', () async {
    when(() => service.getWishlist()).thenAnswer((_) async => [item]);
    await container.read(wishlistProvider.future);

    when(() => service.removeFromWishlist(10)).thenAnswer((_) async {});
    when(() => service.getWishlist()).thenAnswer((_) async => []);

    await container.read(wishlistProvider.notifier).remove(10);

    expect(container.read(wishlistProvider).value, isEmpty);
  });
}
