import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../../../shared/providers/repository_providers.dart';

class MarketplaceFilterState {
  final String selectedCategory;
  final String searchQuery;
  final String selectedLocation;

  const MarketplaceFilterState({
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.selectedLocation = 'All Locations',
  });

  MarketplaceFilterState copyWith({
    String? selectedCategory,
    String? searchQuery,
    String? selectedLocation,
  }) {
    return MarketplaceFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

final marketplaceFilterProvider = StateProvider<MarketplaceFilterState>((ref) {
  return const MarketplaceFilterState();
});

final marketplaceProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  final filter = ref.watch(marketplaceFilterProvider);
  return repo.getProducts(
    category: filter.selectedCategory,
    isAgroStoreOnly: false,
    searchQuery: filter.searchQuery,
    location: filter.selectedLocation,
  );
});

final agroStoreProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProducts(isAgroStoreOnly: true);
});

final productDetailProvider = FutureProvider.family<Product?, String>((ref, id) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getProductById(id);
});
