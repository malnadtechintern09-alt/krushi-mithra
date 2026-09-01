class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String profilePhoto;
  final String address;
  final String locationName;
  final double latitude;
  final double longitude;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.profilePhoto,
    required this.address,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? role,
    String? profilePhoto,
    String? address,
    String? locationName,
    double? latitude,
    double? longitude,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      address: address ?? this.address,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
