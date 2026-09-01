class Booking {
  final String id;
  final String bookingType; // 'machine' or 'worker'
  final String targetId;
  final String targetTitle;
  final String targetImageUrl;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String providerId;
  final String providerName;
  final String providerPhone;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;
  final String paymentMethod; // Cash on Delivery / Online UPI / Pay After Service
  final String paymentStatus; // Pending, Paid
  final String bookingStatus; // Pending, Confirmed, Completed, Cancelled
  final DateTime createdAt;
  final String serviceLocation;

  const Booking({
    required this.id,
    required this.bookingType,
    required this.targetId,
    required this.targetTitle,
    required this.targetImageUrl,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.providerId,
    required this.providerName,
    required this.providerPhone,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.createdAt,
    required this.serviceLocation,
  });

  Booking copyWith({
    String? id,
    String? bookingType,
    String? targetId,
    String? targetTitle,
    String? targetImageUrl,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? providerId,
    String? providerName,
    String? providerPhone,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? bookingStatus,
    DateTime? createdAt,
    String? serviceLocation,
  }) {
    return Booking(
      id: id ?? this.id,
      bookingType: bookingType ?? this.bookingType,
      targetId: targetId ?? this.targetId,
      targetTitle: targetTitle ?? this.targetTitle,
      targetImageUrl: targetImageUrl ?? this.targetImageUrl,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerPhone: providerPhone ?? this.providerPhone,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      createdAt: createdAt ?? this.createdAt,
      serviceLocation: serviceLocation ?? this.serviceLocation,
    );
  }
}
