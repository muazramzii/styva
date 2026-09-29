import 'package:flutter/foundation.dart';

/// Fired by [AuthInterceptor] when a token refresh fails, so [AuthNotifier]
/// can react immediately instead of the app only noticing on its next
/// explicit auth check. Kept decoupled from Riverpod so the Dio layer never
/// depends on app state management.
class SessionExpiryNotifier extends ChangeNotifier {
  void notifySessionExpired() => notifyListeners();
}
