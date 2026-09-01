import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/product_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(productId);

    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: Center(child: Text('Invalid product id: $productId')),
      );
    }

    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load product: $error')),
        data: (product) {
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
                const SizedBox(height: 16),
                Text('Variants', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: ListView.builder(
                    itemCount: product.variants.length,
                    itemBuilder: (context, index) {
                      final variant = product.variants[index];
                      return ListTile(
                        title: Text('${variant.size} / ${variant.color}'),
                        trailing: Text('Stock: ${variant.stock}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
