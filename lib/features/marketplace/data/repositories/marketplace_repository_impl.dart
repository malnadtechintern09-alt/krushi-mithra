import '../../domain/entities/product.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../../../../core/database/sample_data.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final List<Product> _products = List.from(SampleData.initialProducts);

  @override
  Future<List<Product>> getProducts({
    String? category,
    bool? isAgroStoreOnly,
    String? searchQuery,
    String? location,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var results = List<Product>.from(_products);

    if (isAgroStoreOnly != null) {
      results = results.where((p) => p.isAgroStoreItem == isAgroStoreOnly).toList();
    }

    if (category != null && category != 'All') {
      results = results.where((p) => p.category == category).toList();
    }

    if (location != null && location.isNotEmpty && location != 'All Locations') {
      results = results.where((p) => p.location.toLowerCase().contains(location.toLowerCase())).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      results = results.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q)
      ).toList();
    }

    return results;
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.insert(0, product);
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _products.removeWhere((p) => p.id == id);
  }
}
