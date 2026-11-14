import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/state_message.dart';

/// Product search (the `/discover` route). The backend matches product name
/// and description; results update after a short pause in typing.
class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _search = '';

  /// The last results that loaded, shown while the next query is in flight.
  List<ProductModel>? _lastResults;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    // Wait for a pause in typing instead of querying on every keystroke.
    _debounce = Timer(const Duration(milliseconds: 350), () => _apply(value));
    setState(() {}); // shows/hides the clear button immediately
  }

  void _apply(String value) {
    _debounce?.cancel();
    if (mounted) setState(() => _search = value.trim());
  }

  void _clear() {
    _controller.clear();
    _apply('');
  }

  @override
  Widget build(BuildContext context) {
    final ProductQuery query = (category: null, brand: null, search: _search);
    final productsAsync = ref.watch(productListProvider(query));

    // Each query is its own provider, so a new one starts with no data.
    // Showing the previous results until it answers keeps the grid from
    // blinking to a spinner at every pause in typing.
    final loaded = productsAsync.valueOrNull;
    if (loaded != null) _lastResults = loaded;
    final previous = _lastResults;
    final showPrevious = loaded == null && productsAsync.isLoading && previous != null && previous.isNotEmpty;
    final AsyncValue<List<ProductModel>> shown = showPrevious ? AsyncData(previous) : productsAsync;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.sm, AppSpacing.page, AppSpacing.md),
              child: TextField(
                key: const Key('search_field'),
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                onSubmitted: _apply,
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _controller.text.isEmpty
                          ? null
                          : IconButton(icon: const Icon(Icons.close), tooltip: 'Clear search', onPressed: _clear),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 2,
              child: showPrevious ? const LinearProgressIndicator(minHeight: 2, semanticsLabel: 'Searching') : null,
            ),
          ),
          ProductGridSliver(
            products: shown,
            onProductTap: (product) => context.push('/product/${product.id}'),
            onRetry: () => ref.invalidate(productListProvider(query)),
            empty: StateMessage(
              icon: Icons.search_off,
              title: 'No results',
              message:
                  _search.isEmpty ? 'No products are available yet.' : 'Nothing matches "$_search". Try another word.',
            ),
          ),
        ],
      ),
    );
  }
}
