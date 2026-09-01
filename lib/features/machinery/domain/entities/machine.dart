class Machine {
  final String id;
  final String name;
  final String category;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final List<String> images;
  final String description;
  final double rentalPricePerDay;
  final String location;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final Map<String, String> specs;

  const Machine({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.images,
    required this.description,
    required this.rentalPricePerDay,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.isAvailable = true,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.specs = const {},
  });

  Machine copyWith({
    String? id,
    String? name,
    String? category,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    List<String>? images,
    String? description,
    double? rentalPricePerDay,
    String? location,
    double? latitude,
    double? longitude,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    Map<String, String>? specs,
  }) {
    return Machine(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      images: images ?? this.images,
      description: description ?? this.description,
      rentalPricePerDay: rentalPricePerDay ?? this.rentalPricePerDay,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specs: specs ?? this.specs,
    );
  }
}
