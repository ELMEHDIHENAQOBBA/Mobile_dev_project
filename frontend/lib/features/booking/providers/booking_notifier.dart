import 'package:dio/dio.dart';
import 'package:guideme/features/booking/domain/entities/booking_entity.dart';
import 'package:guideme/features/booking/domain/repositories/booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingState {
  final List<BookingEntity> bookings;
  final BookingEntity? newBooking;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.bookings = const [],
    this.newBooking,
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    List<BookingEntity>? bookings,
    BookingEntity? newBooking,
    bool? isLoading,
    String? error,
    bool clearNewBooking = false,
    bool clearError = false,
  }) =>
      BookingState(
        bookings: bookings ?? this.bookings,
        newBooking: clearNewBooking ? null : newBooking ?? this.newBooking,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
      );
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier(this._repository) : super(const BookingState());

  final IBookingRepository _repository;

  Future<void> createBooking({
    required int guideId,
    required String visitDate,
    required int durationHours,
    required int numberOfPeople,
    String? specialRequest,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearNewBooking: true);
    try {
      final booking = await _repository.createBooking(
        guideId: guideId,
        visitDate: visitDate,
        durationHours: durationHours,
        numberOfPeople: numberOfPeople,
        specialRequest: specialRequest,
      );
      state = state.copyWith(newBooking: booking, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Booking failed',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMyBookings() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final bookings = await _repository.getMyBookings();
      state = state.copyWith(bookings: bookings, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Failed to load bookings',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> cancelBooking(int bookingId, {String? reason}) async {
    try {
      final updated = await _repository.updateStatus(bookingId, 'CANCELLED', reason: reason);
      final updatedList = state.bookings
          .map((b) => b.id == bookingId ? updated : b)
          .toList();
      state = state.copyWith(bookings: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearNewBooking() => state = state.copyWith(clearNewBooking: true);
}
