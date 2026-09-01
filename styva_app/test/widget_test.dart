import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:styva_app/features/auth/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage renders its title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashPage(),
        ),
      ),
    );

    expect(find.text('Splash'), findsOneWidget);
  });
}
