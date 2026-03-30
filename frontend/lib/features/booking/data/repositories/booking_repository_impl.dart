import 'package:guideme/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:guideme/features/booking/domain/entities/booking_entity.dart';
import 'package:guideme/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements IBookingRepository {
  BookingRepositoryImpl(this._dataSource);
  final BookingRemoteDataSource _dataSource;

  @override
  Future<BookingEntity> createBooking({
    required int guideId,
    required String visitDate,
    required int durationHours,
    required int numberOfPeople,
    String? specialRequest,
  }) =>
      _dataSource.createBooking(
        guideId: guideId,
        visitDate: visitDate,
        durationHours: durationHours,
        numberOfPeople: numberOfPeople,
        specialRequest: specialRequest,
      );

  @override
  Future<List<BookingEntity>> getMyBookings() => _dataSource.getMyBookings();

  @override
  Future<BookingEntity> updateStatus(int bookingId, String status, {String? reason}) =>
      _dataSource.updateStatus(bookingId, status, reason: reason);
}
