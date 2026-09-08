class Worker {
  final String id;
  final String name;
  final String phone;
  final List<String> skills;
  final int experienceYears;
  final String location;
  final double latitude;
  final double longitude;
  final double dailyRate;
  final bool isAvailable;
  final String availabilityStatus;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String profilePhoto;
  final String bio;

  const Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.skills,
    required this.experienceYears,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.dailyRate,
    this.isAvailable = true,
    this.availabilityStatus = 'Available',
    this.rating = 4.8,
    this.reviewCount = 0,
    this.isVerified = true,
    required this.profilePhoto,
    required this.bio,
  });

  Worker copyWith({
    String? id,
    String? name,
    String? phone,
    List<String>? skills,
    int? experienceYears,
    String? location,
    double? latitude,
    double? longitude,
    double? dailyRate,
    bool? isAvailable,
    String? availabilityStatus,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    String? profilePhoto,
    String? bio,
  }) {
    return Worker(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dailyRate: dailyRate ?? this.dailyRate,
      isAvailable: isAvailable ?? this.isAvailable,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bio: bio ?? this.bio,
    );
  }
}
