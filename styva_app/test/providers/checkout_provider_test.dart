import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/cart_model.dart';
import 'package:styva_app/models/checkout_request_model.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/providers/cart_provider.dart';
import 'package:styva_app/providers/checkout_provider.dart';
import 'package:styva_app/services/cart_service.dart';
import 'package:styva_app/services/checkout_service.dart';

import '../fixtures/order_fixtures.dart';

class MockCheckoutService extends Mock implements CheckoutService {}

class MockCartService extends Mock implements CartService {}

const _addressId = 7;

void main() {
  late MockCheckoutService checkoutService;
  late MockCartService cartService;
  late ProviderContainer container;
  final order = OrderModel.fromJson(orderDetailJson);

  setUpAll(() {
    registerFallbackValue(const CheckoutRequestModel(addressId: _addressId));
  });

  setUp(() {
    checkoutService = MockCheckoutService();
    cartService = MockCartService();
    container = ProviderContainer(overrides: [
      checkoutServiceProvider.overrideWithValue(checkoutService),
      cartServiceProvider.overrideWithValue(cartService),
    ]);
    addTearDown(container.dispose);
    // checkoutProvider is autoDispose; keep it alive for the whole test.
    container.listen(checkoutProvider, (_, __) {});
  });

  test('starts idle', () {
    expect(container.read(checkoutProvider), const CheckoutState.idle());
  });

  test('goes loading while the request is in flight, then success', () async {
    final completer = Completer<OrderModel>();
    when(() => checkoutService.checkout(any())).thenAnswer((_) => completer.future);

    final future = container.read(checkoutProvider.notifier).placeOrder(_addressId);
    expect(container.read(checkoutProvider), const CheckoutState.loading());

    completer.complete(order);
    await future;

    expect(container.read(checkoutProvider), CheckoutState.success(order));
  });

  test('sends only the shipping address', () async {
    when(() => checkoutService.checkout(any())).thenAnswer((_) async => order);

    await container.read(checkoutProvider.notifier).placeOrder(_addressId);

    final request = verify(() => checkoutService.checkout(captureAny())).captured.single
        as CheckoutRequestModel;
    expect(request.addressId, _addressId);
  });

  test('surfaces a readable error message on failure', () async {
    final options = RequestOptions(path: '');
    when(() => checkoutService.checkout(any())).thenThrow(DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: options,
        statusCode: 409,
        data: {'detail': 'Some items in your cart are no longer available in that quantity.'},
      ),
    ));

    await container.read(checkoutProvider.notifier).placeOrder(_addressId);

    expect(
      container.read(checkoutProvider),
      const CheckoutState.error('Some items in your cart are no longer available in that quantity.'),
    );
  });

  test('ignores repeated taps while a checkout is already in flight', () async {
    final completer = Completer<OrderModel>();
    when(() => checkoutService.checkout(any())).thenAnswer((_) => completer.future);
    final notifier = container.read(checkoutProvider.notifier);

    final first = notifier.placeOrder(_addressId);
    final second = notifier.placeOrder(_addressId);
    final third = notifier.placeOrder(_addressId);
    completer.complete(order);
    await Future.wait([first, second, third]);

    verify(() => checkoutService.checkout(any())).called(1);
    expect(container.read(checkoutProvider), CheckoutState.success(order));
  });

  test('refreshes the cart after a successful checkout', () async {
    var cartFetches = 0;
    when(() => cartService.getCart()).thenAnswer((_) async {
      cartFetches++;
      return const CartModel(id: 1, items: [], total: 0);
    });
    container.listen(cartProvider, (_, __) {});
    await container.read(cartProvider.future);
    expect(cartFetches, 1);

    when(() => checkoutService.checkout(any())).thenAnswer((_) async => order);
    await container.read(checkoutProvider.notifier).placeOrder(_addressId);
    await container.read(cartProvider.future);

    expect(cartFetches, 2);
  });

  test('can retry after an error', () async {
    when(() => checkoutService.checkout(any())).thenThrow(Exception('network'));
    await container.read(checkoutProvider.notifier).placeOrder(_addressId);
    expect(container.read(checkoutProvider), isA<CheckoutError>());

    when(() => checkoutService.checkout(any())).thenAnswer((_) async => order);
    await container.read(checkoutProvider.notifier).placeOrder(_addressId);

    expect(container.read(checkoutProvider), CheckoutState.success(order));
  });
}
