import '../../domain/entities/product.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../../../../core/services/api_service.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  List<Product> _products = [];

  @override
  Future<List<Product>> getProducts({
    String? category,
    bool? isAgroStoreOnly,
    String? searchQuery,
    String? location,
  }) async {
    _products = await ApiService().fetchMarketplaceProducts();
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
    if (_products.isEmpty) {
      _products = await ApiService().fetchMarketplaceProducts();
    }
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    _products.insert(0, product);
    try {
      final productMap = {
        'id': product.id,
        'title': product.title,
        'category': product.category,
        'sellerId': product.sellerId,
        'sellerName': product.sellerName,
        'sellerPhone': product.sellerPhone,
        'images': product.images,
        'description': product.description,
        'price': product.price,
        'unit': product.unit,
        'quantityAvailable': product.quantityAvailable,
        'location': product.location,
        'isAgroStoreItem': product.isAgroStoreItem,
        'rating': product.rating,
      };
      await ApiService().submitMarketplaceProduct(productMap);
    } catch (e) {
      // Keep local addition if network fails
    }
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}
