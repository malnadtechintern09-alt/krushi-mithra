import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../core/services/api_service.dart';

class BookingRepositoryImpl implements BookingRepository {
  List<Booking> _bookings = [];

  @override
  Future<List<Booking>> getBookingsForUser(String userId) async {
    _bookings = await ApiService().fetchBookings(userId);
    return _bookings;
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    _bookings.insert(0, booking);
    try {
      final bookingMap = {
        'id': booking.id,
        'bookingType': booking.bookingType,
        'targetId': booking.targetId,
        'targetTitle': booking.targetTitle,
        'targetImageUrl': booking.targetImageUrl,
        'customerId': booking.customerId,
        'customerName': booking.customerName,
        'customerPhone': booking.customerPhone,
        'providerId': booking.providerId,
        'providerName': booking.providerName,
        'providerPhone': booking.providerPhone,
        'startDate': booking.startDate.toIso8601String(),
        'endDate': booking.endDate.toIso8601String(),
        'totalAmount': booking.totalAmount,
        'paymentMethod': booking.paymentMethod,
        'paymentStatus': booking.paymentStatus,
        'bookingStatus': booking.bookingStatus,
        'createdAt': booking.createdAt.toIso8601String(),
        'serviceLocation': booking.serviceLocation,
      };
      await ApiService().submitBooking(bookingMap);
    } catch (_) {}
    return booking;
  }

  @override
  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(bookingStatus: status);
      try {
        await ApiService().updateBookingStatusApi(bookingId, status);
      } catch (_) {}
      return _bookings[index];
    }
    throw Exception('Booking not found');
  }
}
