import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:styva_app/core/router/app_router.dart';
import 'package:styva_app/main.dart';

/// STYVA is laid out for phones. On wider windows (web, tablets) the app is
/// shown as a centred column instead of being stretched edge to edge.
void main() {
  Future<Rect> pageRectAt(WidgetTester tester, double windowWidth) async {
    tester.view.physicalSize = Size(windowWidth, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, __) => const Scaffold(body: SizedBox.expand(key: Key('page'))))],
    );
    await tester.pumpWidget(
      ProviderScope(overrides: [routerProvider.overrideWithValue(router)], child: const StyvaApp()),
    );
    await tester.pumpAndSettle();
    return tester.getRect(find.byKey(const Key('page')));
  }

  testWidgets('a phone-width window uses the full width', (tester) async {
    final page = await pageRectAt(tester, 390);

    expect(page.left, 0);
    expect(page.width, 390);
  });

  testWidgets('a wide window shows the app as a centred 560px column', (tester) async {
    final page = await pageRectAt(tester, 1280);

    expect(page.width, 560);
    expect(page.left, (1280 - 560) / 2);
  });

  testWidgets('pages inside the column see the column width, not the window width', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late double reportedWidth;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) {
            reportedWidth = MediaQuery.sizeOf(context).width;
            return const Scaffold();
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(overrides: [routerProvider.overrideWithValue(router)], child: const StyvaApp()),
    );
    await tester.pumpAndSettle();

    expect(reportedWidth, 560);
  });
}
