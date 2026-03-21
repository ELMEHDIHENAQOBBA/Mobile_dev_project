import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/network/app_network.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:flutter_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_notifier.dart';
import 'package:flutter_clean_architecture/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/guides/data/datasources/guides_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main()');
});

final dioProvider = Provider<Dio>((ref) => AppNetwork.createDio());

final authLocalDataSourceProvider = Provider<IAuthLocalDataSource>((ref) =>
    AuthLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)));

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) =>
    AuthRemoteDataSourceImpl(ref.watch(dioProvider)));

final authRepositoryProvider = Provider<IAuthRepository>((ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider),
        ref.watch(authLocalDataSourceProvider)));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(authRepositoryProvider)));

// Guides
final guidesDataSourceProvider = Provider<GuidesRemoteDataSource>(
    (ref) => GuidesRemoteDataSource(ref.watch(dioProvider)));

// Booking
final bookingDataSourceProvider = Provider<BookingRemoteDataSource>(
    (ref) => BookingRemoteDataSource(ref.watch(dioProvider)));

// Payment
final paymentDataSourceProvider = Provider<PaymentRemoteDataSource>(
    (ref) => PaymentRemoteDataSource(ref.watch(dioProvider)));

// Review
final reviewDataSourceProvider = Provider<ReviewRemoteDataSource>(
    (ref) => ReviewRemoteDataSource(ref.watch(dioProvider)));
