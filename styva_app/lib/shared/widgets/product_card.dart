import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../models/product_model.dart';
import 'product_image.dart';

/// Grid tile used wherever products are listed: image first, then brand,
/// name (two lines max) and price.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '${product.brand.name} ${product.name}, ${formatMoney(product.price)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(url: product.image, label: product.brand.name, borderRadius: AppRadius.md),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.brand.name.toUpperCase(),
              style: AppTypography.eyebrow,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              product.name,
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(formatMoney(product.price), style: AppTypography.price),
          ],
        ),
      ),
    );
  }
}
