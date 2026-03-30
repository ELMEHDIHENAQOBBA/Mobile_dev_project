import 'package:dio/dio.dart';
import 'package:guideme/features/guide_space/data/datasources/guide_dashboard_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuideDashboardState {
  final Map<String, dynamic>? dashboardData;
  final List<dynamic> incomingBookings;
  final bool isLoading;
  final String? error;

  const GuideDashboardState({
    this.dashboardData,
    this.incomingBookings = const [],
    this.isLoading = false,
    this.error,
  });

  GuideDashboardState copyWith({
    Map<String, dynamic>? dashboardData,
    List<dynamic>? incomingBookings,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      GuideDashboardState(
        dashboardData: dashboardData ?? this.dashboardData,
        incomingBookings: incomingBookings ?? this.incomingBookings,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
      );
}

class GuideDashboardNotifier extends StateNotifier<GuideDashboardState> {
  GuideDashboardNotifier(this._dataSource) : super(const GuideDashboardState());

  final GuideDashboardDataSource _dataSource;

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _dataSource.loadDashboard();
      state = state.copyWith(dashboardData: data, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Failed to load dashboard',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadIncomingBookings() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final bookings = await _dataSource.loadIncomingBookings();
      state = state.copyWith(incomingBookings: bookings, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? 'Failed to load bookings',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await _dataSource.updateBookingStatus(bookingId, status);
      await loadIncomingBookings();
    } on DioException catch (e) {
      state = state.copyWith(
        error: e.response?.data?['message'] ?? 'Failed to update status',
      );
    }
  }
}
