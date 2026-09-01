import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../core/database/sample_data.dart';

class BookingRepositoryImpl implements BookingRepository {
  final List<Booking> _bookings = List.from(SampleData.initialBookings);

  @override
  Future<List<Booking>> getBookingsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _bookings.where((b) => b.customerId == userId || b.providerId == userId).toList();
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(bookingStatus: status);
      return _bookings[index];
    }
    throw Exception('Booking not found');
  }
}
