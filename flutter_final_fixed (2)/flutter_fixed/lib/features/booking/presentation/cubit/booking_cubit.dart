import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/booking/domain/entities/booking_entity.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._ds) : super(BookingInitial());
  final BookingRemoteDataSource _ds;

  Future<void> createBooking({
    required int guideId, required String visitDate,
    required int durationHours, required int numberOfPeople,
    String? specialRequest,
  }) async {
    emit(BookingLoading());
    try {
      final booking = await _ds.createBooking(
        guideId: guideId, visitDate: visitDate,
        durationHours: durationHours, numberOfPeople: numberOfPeople,
        specialRequest: specialRequest,
      );
      emit(BookingSuccess(booking));
    } on DioException catch (e) {
      emit(BookingError(e.response?.data?['message'] ?? 'Booking failed'));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> loadMyBookings() async {
    emit(BookingLoading());
    try {
      final bookings = await _ds.getMyBookings();
      emit(BookingsLoaded(bookings));
    } on DioException catch (e) {
      emit(BookingError(e.response?.data?['message'] ?? 'Failed to load bookings'));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> cancelBooking(int bookingId, {String? reason}) async {
    try {
      await _ds.updateStatus(bookingId, 'CANCELLED', reason: reason);
      await loadMyBookings();
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
