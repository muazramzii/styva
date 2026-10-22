import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/api_error.dart';
import '../../models/product_model.dart';
import 'product_card.dart';
import 'state_message.dart';

/// Two-column product grid as a sliver, including its loading, error
/// (with Retry) and empty states.
class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onRetry,
    required this.empty,
  });

  final AsyncValue<List<ProductModel>> products;
  final ValueChanged<ProductModel> onProductTap;
  final VoidCallback onRetry;
  final StateMessage empty;

  @override
  Widget build(BuildContext context) {
    return products.when(
      skipLoadingOnRefresh: false,
      loading:
          () => const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(padding: EdgeInsets.all(AppSpacing.xxl), child: Center(child: CircularProgressIndicator())),
          ),
      error:
          (error, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: StateMessage.error(
              title: 'Could not load products',
              message: extractApiErrorMessage(error),
              onRetry: onRetry,
            ),
          ),
      data: (items) {
        if (items.isEmpty) return SliverFillRemaining(hasScrollBody: false, child: empty);
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.xxl),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              const columns = 2;
              const gap = AppSpacing.lg;
              final tileWidth = (constraints.crossAxisExtent - gap * (columns - 1)) / columns;
              // Image (3:4) plus brand, two-line name and price, scaled with
              // the user's text size so large fonts never overflow the tile.
              final textHeight = ProductCard.textBlockHeight(MediaQuery.textScalerOf(context));
              return SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: gap,
                  mainAxisSpacing: AppSpacing.xl,
                  mainAxisExtent: tileWidth * 4 / 3 + textHeight,
                ),
                itemCount: items.length,
                itemBuilder:
                    (context, index) => ProductCard(product: items[index], onTap: () => onProductTap(items[index])),
              );
            },
          ),
        );
      },
    );
  }
}
