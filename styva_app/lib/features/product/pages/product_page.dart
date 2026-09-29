import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/api_error.dart';
import '../../../models/product_model.dart';
import '../../../models/variant_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/wishlist_provider.dart';

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
      await ref.read(cartProvider.notifier).addItem(
            variantId: variant!.id,
            quantity: _quantity,
          );
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
        appBar: AppBar(title: const Text('Product')),
        body: Center(child: Text('Invalid product id: ${widget.productId}')),
      );
    }

    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load product: $error')),
        data: (product) => _ProductDetailBody(
          product: product,
          selectedColor: _selectedColor,
          selectedSize: _selectedSize,
          quantity: _quantity,
          isSubmitting: _isSubmitting,
          onColorSelected: (color) => setState(() {
            _selectedColor = color;
            _selectedSize = null;
            _quantity = 1;
          }),
          onSizeSelected: (size) => setState(() {
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
    final hasVariants = product.variants.isNotEmpty;
    final colors = product.variants.map((v) => v.color).toSet().toList();
    final sizesForColor = product.variants
        .where((v) => v.color == selectedColor)
        .map((v) => v.size)
        .toSet()
        .toList();

    final canAddToCart = isSubmitting
        ? false
        : !hasVariants || (selectedVariant != null && selectedVariant!.stock > 0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('RM ${product.price.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Brand: ${product.brand.name}'),
          if (hasVariants) ...[
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: colors
                  .map((color) => ChoiceChip(
                        label: Text(color),
                        selected: selectedColor == color,
                        onSelected: (_) => onColorSelected(color),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Size', style: Theme.of(context).textTheme.titleMedium),
            if (selectedColor == null)
              const Text('Select a color first')
            else
              Wrap(
                spacing: 8,
                children: sizesForColor
                    .map((size) => ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          onSelected: (_) => onSizeSelected(size),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 16),
            if (selectedVariant != null) ...[
              Text(
                selectedVariant!.stock > 0
                    ? 'In stock: ${selectedVariant!.stock}'
                    : 'Out of stock',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Quantity'),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$quantity'),
                  IconButton(
                    onPressed: quantity < selectedVariant!.stock
                        ? () => onQuantityChanged(quantity + 1)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : onAddToWishlist,
                  child: const Text('Add to Wishlist'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: canAddToCart ? onAddToCart : null,
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
