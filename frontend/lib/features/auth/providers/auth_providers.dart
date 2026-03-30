import 'package:dio/dio.dart';
import 'package:guideme/core/network/app_network.dart';
import 'package:guideme/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:guideme/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:guideme/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:guideme/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:guideme/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guideme/features/auth/domain/repositories/auth_repository.dart';
import 'package:guideme/features/auth/providers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main()');
});

final dioProvider = Provider<Dio>((ref) => AppNetwork.createDio());

final authLocalDataSourceProvider = Provider<IAuthLocalDataSource>(
    (ref) => AuthLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)));

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>(
    (ref) => AuthRemoteDataSourceImpl(ref.watch(dioProvider)));

final authRepositoryProvider = Provider<IAuthRepository>((ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider),
        ref.watch(authLocalDataSourceProvider)));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(authRepositoryProvider)));
