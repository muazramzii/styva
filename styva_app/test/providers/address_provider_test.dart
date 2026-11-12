import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/address_model.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/address_provider.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/services/address_service.dart';

import '../fixtures/address_fixtures.dart';

class MockAddressService extends Mock implements AddressService {}

const _input = AddressInput(
  recipientName: 'Ali Bin Abu',
  phone: '0198765432',
  addressLine1: '123 Jalan ABC',
  city: 'Skudai',
  state: 'Johor',
  postcode: '81300',
);

void main() {
  late MockAddressService service;
  late ProviderContainer container;
  late StateController<UserModel?> signedIn;

  final userA = UserModel(id: 1, fullName: 'A', email: 'a@example.com', createdAt: DateTime.utc(2026));
  final userB = UserModel(id: 2, fullName: 'B', email: 'b@example.com', createdAt: DateTime.utc(2026));
  final home = address(id: 1, isDefault: true);
  final office = address(id: 2, isDefault: false, recipientName: 'Office');

  setUpAll(() => registerFallbackValue(_input));

  setUp(() {
    service = MockAddressService();
    final userState = StateProvider<UserModel?>((ref) => userA);
    container = ProviderContainer(overrides: [
      addressServiceProvider.overrideWithValue(service),
      currentUserProvider.overrideWith((ref) => ref.watch(userState)),
    ]);
    signedIn = container.read(userState.notifier);
    addTearDown(container.dispose);
  });

  // Start watching only after the test has stubbed the first fetch.
  void start() => container.listen(addressesProvider, (_, __) {});

  test('loads the saved addresses', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home, office]);
    start();

    expect(container.read(addressesProvider), isA<AsyncLoading<List<AddressModel>>>());
    expect(await container.read(addressesProvider.future), [home, office]);
  });

  test('a load failure surfaces as an error state', () async {
    when(() => service.getAddresses()).thenThrow(Exception('offline'));
    start();

    await expectLater(container.read(addressesProvider.future), throwsException);
    expect(container.read(addressesProvider).hasError, isTrue);
  });

  test('create re-fetches so default flags come from the server', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home]);
    start();
    await container.read(addressesProvider.future);
    final created = address(id: 3, isDefault: true, recipientName: 'New');
    when(() => service.createAddress(any())).thenAnswer((_) async => created);
    when(() => service.getAddresses())
        .thenAnswer((_) async => [created, home.copyWith(isDefault: false)]);

    final result = await container.read(addressesProvider.notifier).create(_input);

    expect(result, created);
    final list = container.read(addressesProvider).value!;
    expect(list.where((a) => a.isDefault).map((a) => a.id), [3]);
  });

  test('save updates an address and re-fetches', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home]);
    start();
    await container.read(addressesProvider.future);
    final edited = home.copyWith(addressLine1: '456 Jalan XYZ');
    when(() => service.updateAddress(1, any())).thenAnswer((_) async => edited);
    when(() => service.getAddresses()).thenAnswer((_) async => [edited]);

    await container.read(addressesProvider.notifier).save(1, _input);

    expect(container.read(addressesProvider).value!.single.addressLine1, '456 Jalan XYZ');
  });

  test('setDefault moves the default to the chosen address', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home, office]);
    start();
    await container.read(addressesProvider.future);
    when(() => service.setDefault(2)).thenAnswer((_) async => office.copyWith(isDefault: true));
    when(() => service.getAddresses())
        .thenAnswer((_) async => [office.copyWith(isDefault: true), home.copyWith(isDefault: false)]);

    await container.read(addressesProvider.notifier).setDefault(2);

    final list = container.read(addressesProvider).value!;
    expect(list.where((a) => a.isDefault).map((a) => a.id), [2]);
  });

  test('delete removes the address and re-fetches', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home, office]);
    start();
    await container.read(addressesProvider.future);
    when(() => service.deleteAddress(1)).thenAnswer((_) async {});
    when(() => service.getAddresses()).thenAnswer((_) async => [office.copyWith(isDefault: true)]);

    await container.read(addressesProvider.notifier).delete(1);

    expect(container.read(addressesProvider).value!.map((a) => a.id), [2]);
  });

  test('a failed mutation throws and leaves the list as it was', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home, office]);
    start();
    await container.read(addressesProvider.future);
    final options = RequestOptions(path: '');
    when(() => service.deleteAddress(2)).thenThrow(DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: 404),
    ));

    await expectLater(container.read(addressesProvider.notifier).delete(2), throwsA(isA<DioException>()));
    expect(container.read(addressesProvider).value, [home, office]);
  });

  test('re-fetches when a different user signs in', () async {
    when(() => service.getAddresses()).thenAnswer((_) async => [home]);
    start();
    await container.read(addressesProvider.future);

    when(() => service.getAddresses()).thenAnswer((_) async => []);
    signedIn.state = userB;

    expect(await container.read(addressesProvider.future), isEmpty);
    verify(() => service.getAddresses()).called(2);
  });
}
