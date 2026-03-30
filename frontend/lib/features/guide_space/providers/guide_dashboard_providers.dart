import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/guide_space/data/datasources/guide_dashboard_data_source.dart';
import 'package:guideme/features/guide_space/providers/guide_dashboard_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _guideDashboardDataSourceProvider = Provider<GuideDashboardDataSource>(
    (ref) => GuideDashboardDataSource(ref.watch(dioProvider)));

final guideDashboardNotifierProvider =
    StateNotifierProvider<GuideDashboardNotifier, GuideDashboardState>(
        (ref) => GuideDashboardNotifier(
            ref.watch(_guideDashboardDataSourceProvider)));
