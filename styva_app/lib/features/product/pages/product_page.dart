import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/api_error.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product_model.dart';
import '../../../models/variant_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/state_message.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;
  bool _isSubmitting = false;

  VariantModel? _variantFor(ProductModel product, String? color, String? size) {
    if (color == null || size == null) return null;
    for (final variant in product.variants) {
      if (variant.color == color && variant.size == size) return variant;
    }
    return null;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addToWishlist(ProductModel product) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(wishlistProvider.notifier).add(product.id);
      _showMessage('Added to wishlist');
    } catch (e) {
      _showMessage(extractApiErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _addToCart(ProductModel product) async {
    if (product.variants.isNotEmpty) {
      final variant = _variantFor(product, _selectedColor, _selectedSize);
      if (variant == null) {
        _showMessage('Select a color and size first');
        return;
      }
      if (variant.stock < _quantity) {
        _showMessage('Out of stock');
        return;
      }
    }

    final variant = _variantFor(product, _selectedColor, _selectedSize);
    setState(() => _isSubmitting = true);
    try {
      await ref.read(cartProvider.notifier).addItem(variantId: variant!.id, quantity: _quantity);
      _showMessage('Added to cart');
    } catch (e) {
      _showMessage(extractApiErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(widget.productId);

    if (id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: StateMessage(
          icon: Icons.search_off,
          title: 'Product not found',
          message: 'This link does not point to a product.',
          actionLabel: 'Back to Home',
          onAction: () => context.go(AppRoutes.home),
        ),
      );
    }

    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => StateMessage.error(
              title: 'Could not load this product',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(productDetailProvider(id)),
            ),
        data:
            (product) => _ProductDetailBody(
              product: product,
              selectedColor: _selectedColor,
              selectedSize: _selectedSize,
              quantity: _quantity,
              isSubmitting: _isSubmitting,
              onColorSelected:
                  (color) => setState(() {
                    _selectedColor = color;
                    _selectedSize = null;
                    _quantity = 1;
                  }),
              onSizeSelected:
                  (size) => setState(() {
                    _selectedSize = size;
                    _quantity = 1;
                  }),
              onQuantityChanged: (quantity) => setState(() => _quantity = quantity),
              onAddToWishlist: () => _addToWishlist(product),
              onAddToCart: () => _addToCart(product),
              selectedVariant: _variantFor(product, _selectedColor, _selectedSize),
            ),
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.isSubmitting,
    required this.onColorSelected,
    required this.onSizeSelected,
    required this.onQuantityChanged,
    required this.onAddToWishlist,
    required this.onAddToCart,
    required this.selectedVariant,
  });

  final ProductModel product;
  final String? selectedColor;
  final String? selectedSize;
  final int quantity;
  final bool isSubmitting;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToWishlist;
  final VoidCallback onAddToCart;
  final VariantModel? selectedVariant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasVariants = product.variants.isNotEmpty;
    final colors = product.variants.map((v) => v.color).toSet().toList();
    final sizesForColor = product.variants.where((v) => v.color == selectedColor).map((v) => v.size).toSet().toList();

    final canAddToCart = isSubmitting ? false : !hasVariants || (selectedVariant != null && selectedVariant!.stock > 0);

    final description = product.description?.trim() ?? '';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The photo leads, but never takes more than ~55% of the
                // screen so the essentials stay in view.
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxHeight = MediaQuery.sizeOf(context).height * 0.55;
                    final height = (constraints.maxWidth * 5 / 4).clamp(0.0, maxHeight);
                    return SizedBox(
                      height: height,
                      child: ProductImage(
                        url: product.image,
                        label: product.brand.name,
                        aspectRatio: constraints.maxWidth / height,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.xl, AppSpacing.page, AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand.name.toUpperCase(), style: AppTypography.eyebrow),
                      const SizedBox(height: AppSpacing.xs),
                      Text(product.name, style: textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(formatMoney(product.price), style: AppTypography.price.copyWith(fontSize: 18)),
                      if (hasVariants) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _OptionLabel(label: 'Color', value: selectedColor),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children:
                              colors
                                  .map(
                                    (color) => ChoiceChip(
                                      label: Text(color),
                                      selected: selectedColor == color,
                                      onSelected: (_) => onColorSelected(color),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _OptionLabel(label: 'Size', value: selectedSize),
                        const SizedBox(height: AppSpacing.sm),
                        if (selectedColor == null)
                          Text(
                            'Select a color first',
                            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          )
                        else
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children:
                                sizesForColor
                                    .map(
                                      (size) => ChoiceChip(
                                        label: Text(size),
                                        selected: selectedSize == size,
                                        onSelected: (_) => onSizeSelected(size),
                                      ),
                                    )
                                    .toList(),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        _Availability(variant: selectedVariant),
                        if (selectedVariant != null && selectedVariant!.stock > 0) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _QuantityStepper(
                            quantity: quantity,
                            max: selectedVariant!.stock,
                            onChanged: onQuantityChanged,
                          ),
                        ],
                      ],
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        const Divider(),
                        const SizedBox(height: AppSpacing.lg),
                        Text('DETAILS', style: AppTypography.eyebrow),
                        const SizedBox(height: AppSpacing.sm),
                        Text(description, style: textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: isSubmitting ? null : onAddToWishlist,
                      child: const Text('Add to Wishlist', maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: canAddToCart ? onAddToCart : null,
                      child: const Text('Add to Cart', maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "COLOR · Black" style label above an option group.
class _OptionLabel extends StatelessWidget {
  const _OptionLabel({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label.toUpperCase(),
        style: AppTypography.eyebrow,
        children: [
          if (value != null)
            TextSpan(text: '  ·  $value', style: AppTypography.eyebrow.copyWith(color: AppColors.charcoal)),
        ],
      ),
    );
  }
}

class _Availability extends StatelessWidget {
  const _Availability({required this.variant});

  final VariantModel? variant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final v = variant;
    if (v == null) {
      return Text('Choose a color and size to see availability', style: textTheme.bodySmall);
    }
    final inStock = v.stock > 0;
    return Row(
      children: [
        Icon(
          inStock ? Icons.check_circle_outline : Icons.remove_circle_outline,
          size: 18,
          color: inStock ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          inStock ? 'In stock: ${v.stock}' : 'Out of stock',
          style: textTheme.bodyMedium?.copyWith(
            color: inStock ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.max, required this.onChanged});

  final int quantity;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('QUANTITY', style: AppTypography.eyebrow),
        const Spacer(),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Decrease quantity',
                onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
                icon: const Icon(Icons.remove, size: 18),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                  semanticsLabel: 'Quantity $quantity',
                ),
              ),
              IconButton(
                tooltip: 'Increase quantity',
                onPressed: quantity < max ? () => onChanged(quantity + 1) : null,
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
