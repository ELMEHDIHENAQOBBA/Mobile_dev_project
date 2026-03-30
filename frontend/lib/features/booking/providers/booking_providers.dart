import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:guideme/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:guideme/features/booking/domain/repositories/booking_repository.dart';
import 'package:guideme/features/booking/providers/booking_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _bookingDataSourceProvider = Provider<BookingRemoteDataSource>(
    (ref) => BookingRemoteDataSource(ref.watch(dioProvider)));

final _bookingRepositoryProvider = Provider<IBookingRepository>(
    (ref) => BookingRepositoryImpl(ref.watch(_bookingDataSourceProvider)));

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, BookingState>(
        (ref) => BookingNotifier(ref.watch(_bookingRepositoryProvider)));
