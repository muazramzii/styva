import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/session_expiry_notifier.dart';
import '../services/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final sessionExpiryNotifierProvider = Provider<SessionExpiryNotifier>((ref) {
  final notifier = SessionExpiryNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(tokenStorageProvider),
    ref.watch(sessionExpiryNotifierProvider),
  );
});
