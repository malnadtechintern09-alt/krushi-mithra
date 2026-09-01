class Product {
  final String id;
  final String title;
  final String category;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final List<String> images;
  final String description;
  final double price;
  final String unit; // kg, quintal, bag, item, liter
  final double quantityAvailable;
  final String location;
  final bool isAgroStoreItem;
  final double rating;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.images,
    required this.description,
    required this.price,
    required this.unit,
    required this.quantityAvailable,
    required this.location,
    this.isAgroStoreItem = false,
    this.rating = 4.5,
  });

  Product copyWith({
    String? id,
    String? title,
    String? category,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    List<String>? images,
    String? description,
    double? price,
    String? unit,
    double? quantityAvailable,
    String? location,
    bool? isAgroStoreItem,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      images: images ?? this.images,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      location: location ?? this.location,
      isAgroStoreItem: isAgroStoreItem ?? this.isAgroStoreItem,
      rating: rating ?? this.rating,
    );
  }
}
