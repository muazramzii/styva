import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/address_model.dart';
import '../services/address_service.dart';
import 'api_provider.dart';
import 'auth_provider.dart';

final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService(ref.watch(apiClientProvider).dio);
});

/// The signed-in user's saved addresses (default first).
///
/// Every mutation re-fetches the list instead of patching it locally,
/// because the backend may change *other* addresses too (e.g. clearing the
/// old default, or promoting a new one when the default is deleted).
/// Mutations throw on failure so the calling screen can show the error.
class AddressesNotifier extends AutoDisposeAsyncNotifier<List<AddressModel>> {
  @override
  Future<List<AddressModel>> build() {
    // Rebuild for a different signed-in user so one account's addresses can
    // never be shown to the next.
    ref.watch(currentUserProvider.select((user) => user?.id));
    return _service.getAddresses();
  }

  AddressService get _service => ref.read(addressServiceProvider);

  Future<AddressModel> create(AddressInput input) async {
    final address = await _service.createAddress(input);
    await _reload();
    return address;
  }

  Future<AddressModel> save(int id, AddressInput input) async {
    final address = await _service.updateAddress(id, input);
    await _reload();
    return address;
  }

  Future<void> setDefault(int id) async {
    await _service.setDefault(id);
    await _reload();
  }

  Future<void> delete(int id) async {
    await _service.deleteAddress(id);
    await _reload();
  }

  Future<void> _reload() async {
    state = AsyncData(await _service.getAddresses());
  }
}

final addressesProvider =
    AsyncNotifierProvider.autoDispose<AddressesNotifier, List<AddressModel>>(AddressesNotifier.new);
