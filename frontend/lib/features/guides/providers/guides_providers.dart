import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/guides/data/datasources/guides_remote_data_source.dart';
import 'package:guideme/features/guides/data/repositories/guides_repository_impl.dart';
import 'package:guideme/features/guides/domain/repositories/guides_repository.dart';
import 'package:guideme/features/guides/providers/guides_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _guidesDataSourceProvider = Provider<GuidesRemoteDataSource>(
    (ref) => GuidesRemoteDataSource(ref.watch(dioProvider)));

final _guidesRepositoryProvider = Provider<IGuidesRepository>(
    (ref) => GuidesRepositoryImpl(ref.watch(_guidesDataSourceProvider)));

final guidesNotifierProvider =
    StateNotifierProvider<GuidesNotifier, GuidesState>(
        (ref) => GuidesNotifier(ref.watch(_guidesRepositoryProvider)));
