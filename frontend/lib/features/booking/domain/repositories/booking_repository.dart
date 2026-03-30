import 'package:guideme/features/booking/domain/entities/booking_entity.dart';

abstract interface class IBookingRepository {
  Future<BookingEntity> createBooking({
    required int guideId,
    required String visitDate,
    required int durationHours,
    required int numberOfPeople,
    String? specialRequest,
  });

  Future<List<BookingEntity>> getMyBookings();

  Future<BookingEntity> updateStatus(int bookingId, String status, {String? reason});
}
