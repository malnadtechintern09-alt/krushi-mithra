import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookingsForUser(String userId);
  Future<Booking> createBooking(Booking booking);
  Future<Booking> updateBookingStatus(String bookingId, String status);
}
