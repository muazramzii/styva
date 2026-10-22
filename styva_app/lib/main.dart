import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: StyvaApp()));
}

/// The bundled brand fonts are SIL OFL 1.1; their licences ship with the app
/// and appear on Flutter's licence page.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['Cormorant Garamond'],
      await rootBundle.loadString('assets/fonts/OFL-CormorantGaramond.txt'),
    );
    yield LicenseEntryWithLineBreaks(['Lato'], await rootBundle.loadString('assets/fonts/OFL-Lato.txt'));
  });
}

class StyvaApp extends ConsumerWidget {
  const StyvaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
