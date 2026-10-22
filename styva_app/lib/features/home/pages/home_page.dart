import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/product_provider.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/state_message.dart';
import '../../../shared/widgets/styva_wordmark.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// Category / brand slugs; null means "all". Filtering is done by the API.
  String? _category;
  String? _brand;

  ProductQuery get _query => (category: _category, brand: _brand, search: null);

  void _clearFilters() => setState(() {
    _category = null;
    _brand = null;
  });

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider(_query));
    final categories = ref.watch(categoryProvider).valueOrNull ?? const [];
    final brands = ref.watch(brandProvider).valueOrNull ?? const [];
    final hasFilters = _category != null || _brand != null;

    return Scaffold(
      appBar: AppBar(
        // Wordmark on the left, actions on the right: with four actions a
        // centred title would be pushed off-centre.
        centerTitle: false,
        titleSpacing: AppSpacing.page,
        title: const StyvaWordmark(),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Wishlist',
            onPressed: () => context.push(AppRoutes.wishlist),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            tooltip: 'Cart',
            onPressed: () => context.push(AppRoutes.cart),
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'My Orders',
            onPressed: () => context.push(AppRoutes.orders),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Account',
            onPressed: () => context.push(AppRoutes.profile),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryProvider);
          ref.invalidate(brandProvider);
          try {
            ref.invalidate(productListProvider(_query));
            await ref.read(productListProvider(_query).future);
          } catch (_) {
            // The grid shows the error state with a Retry button.
          }
        },
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _EditorialHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, 0),
                child: _SearchEntry(onTap: () => context.push(AppRoutes.discover)),
              ),
            ),
            if (categories.isNotEmpty)
              SliverToBoxAdapter(
                child: _FilterRow(
                  label: 'Categories',
                  options: [for (final c in categories) (c.slug, c.name)],
                  selected: _category,
                  allLabel: 'All',
                  onSelected: (slug) => setState(() => _category = slug),
                ),
              ),
            if (brands.isNotEmpty)
              SliverToBoxAdapter(
                child: _FilterRow(
                  label: 'Brands',
                  options: [for (final b in brands) (b.slug, b.name)],
                  selected: _brand,
                  allLabel: 'All brands',
                  onSelected: (slug) => setState(() => _brand = slug),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            ProductGridSliver(
              products: productsAsync,
              onProductTap: (product) => context.push('/product/${product.id}'),
              onRetry: () => ref.invalidate(productListProvider(_query)),
              empty: StateMessage(
                icon: Icons.checkroom_outlined,
                title: hasFilters ? 'Nothing matches yet' : 'No products yet',
                message: hasFilters ? 'Try another category or brand.' : 'New pieces will appear here soon.',
                actionLabel: hasFilters ? 'Clear filters' : null,
                onAction: hasFilters ? _clearFilters : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorialHeader extends StatelessWidget {
  const _EditorialHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.xl, AppSpacing.page, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('THE COLLECTION', style: AppTypography.eyebrow.copyWith(color: AppColors.sandDark)),
          const SizedBox(height: AppSpacing.sm),
          Text('Modern essentials,\nthoughtfully chosen.', style: textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Unisex pieces from the brands you love.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Looks like a search field; opens the search screen.
class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search products',
      excludeSemantics: true,
      child: Material(
        color: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Search products',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled, horizontally scrolling row of single-select chips with an
/// "all" option first.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.allLabel,
    required this.onSelected,
  });

  final String label;
  final List<(String, String)> options; // (slug, display name)
  final String? selected;
  final String allLabel;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      ChoiceChip(label: Text(allLabel), selected: selected == null, onSelected: (_) => onSelected(null)),
      for (final (slug, name) in options)
        ChoiceChip(label: Text(name), selected: selected == slug, onSelected: (_) => onSelected(slug)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Text(label.toUpperCase(), style: AppTypography.eyebrow),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Row(
              children: [
                for (final chip in chips) Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: chip),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
