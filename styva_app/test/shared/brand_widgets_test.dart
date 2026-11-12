import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/core/theme/app_colors.dart';
import 'package:styva_app/core/theme/app_theme.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/shared/widgets/product_card.dart';
import 'package:styva_app/shared/widgets/product_image.dart';
import 'package:styva_app/shared/widgets/state_message.dart';
import 'package:styva_app/shared/widgets/status_badge.dart';
import 'package:styva_app/shared/widgets/styva_wordmark.dart';

const _product = ProductModel(
  id: 7,
  sku: 'UNQ001',
  name: 'Oversized Cotton Shirt With A Rather Long Product Name That Wraps',
  price: 89.9,
  brand: BrandModel(id: 1, name: 'UNIQLO', slug: 'uniqlo'),
  category: CategoryModel(id: 1, name: 'Tops', slug: 'tops'),
);

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: child));

void main() {
  group('theme', () {
    test('uses the STYVA palette for primary actions and pages', () {
      final theme = AppTheme.lightTheme;
      expect(theme.colorScheme.primary, AppColors.charcoal);
      expect(theme.colorScheme.onPrimary, AppColors.ivory);
      expect(theme.scaffoldBackgroundColor, AppColors.ivory);
      expect(theme.colorScheme.secondary, AppColors.sand);
    });
  });

  testWidgets('wordmark reads as STYVA to screen readers', (tester) async {
    await tester.pumpWidget(_wrap(const StyvaWordmark()));
    expect(find.bySemanticsLabel('STYVA'), findsOneWidget);
  });

  testWidgets('product image without a URL shows the labelled placeholder', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox(width: 200, child: ProductImage(url: null, label: 'UNIQLO'))));

    expect(find.byIcon(Icons.checkroom_outlined), findsOneWidget);
    expect(find.text('UNIQLO'), findsOneWidget);
  });

  testWidgets('product image falls back gracefully when loading fails', (tester) async {
    await tester.pumpWidget(
      _wrap(const SizedBox(width: 200, child: ProductImage(url: 'http://127.0.0.1:9/missing.png', label: 'UNIQLO'))),
    );
    await tester.pumpAndSettle();

    // Network images fail in widget tests, which exercises the error path.
    expect(find.byIcon(Icons.checkroom_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('product card shows brand, name and price and is tappable', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(SizedBox(width: 180, height: 400, child: ProductCard(product: _product, onTap: () => tapped = true))),
    );

    expect(find.text('UNIQLO'), findsWidgets);
    expect(find.text(_product.name), findsOneWidget);
    expect(find.text('RM 89.90'), findsOneWidget);
    await tester.tap(find.byType(ProductCard));
    expect(tapped, isTrue);
  });

  for (final scale in [1.0, 1.3, 1.6, 2.0]) {
    testWidgets('product card fits its grid tile at text scale $scale', (tester) async {
      final scaler = TextScaler.linear(scale);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(textScaler: scaler),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 150,
                  // The tile height the product grid allocates.
                  height: 150 * 4 / 3 + ProductCard.textBlockHeight(scaler),
                  child: ProductCard(product: _product, onTap: () {}),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('error state offers Retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(_wrap(StateMessage.error(message: 'Network down', onRetry: () => retried = true)));

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Network down'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('status badge shows the status in capitals', (tester) async {
    await tester.pumpWidget(
      _wrap(const Column(children: [StatusBadge(status: 'paid'), StatusBadge(status: 'pending')])),
    );

    expect(find.text('PAID'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);
  });
}
