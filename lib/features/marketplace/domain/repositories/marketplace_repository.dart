import '../entities/product.dart';

abstract class MarketplaceRepository {
  Future<List<Product>> getProducts({
    String? category,
    bool? isAgroStoreOnly,
    String? searchQuery,
    String? location,
  });
  Future<Product?> getProductById(String id);
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
