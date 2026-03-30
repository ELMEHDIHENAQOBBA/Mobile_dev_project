part of 'booking_cubit.dart';

abstract class BookingState {}
class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {
  final BookingEntity booking;
  BookingSuccess(this.booking);
}
class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  BookingsLoaded(this.bookings);
}
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
