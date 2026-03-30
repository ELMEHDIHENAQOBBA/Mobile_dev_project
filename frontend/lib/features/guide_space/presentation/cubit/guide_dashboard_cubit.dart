import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'guide_dashboard_state.dart';

class GuideDashboardCubit extends Cubit<GuideDashboardState> {
  GuideDashboardCubit(this._dio) : super(GuideDashboardInitial());
  final Dio _dio;

  Future<void> loadDashboard() async {
    emit(GuideDashboardLoading());
    try {
      final response = await _dio.get('/guide/dashboard');
      emit(GuideDashboardLoaded(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      emit(GuideDashboardError(e.response?.data?['message'] ?? 'Failed to load dashboard'));
    } catch (e) {
      emit(GuideDashboardError(e.toString()));
    }
  }

  Future<void> loadIncomingBookings() async {
    emit(GuideDashboardLoading());
    try {
      final response = await _dio.get('/bookings/incoming');
      emit(GuideBookingsLoaded(response.data['data'] as List));
    } on DioException catch (e) {
      emit(GuideDashboardError(e.response?.data?['message'] ?? 'Failed to load bookings'));
    } catch (e) {
      emit(GuideDashboardError(e.toString()));
    }
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await _dio.patch('/bookings/$bookingId/status', data: {'status': status});
      await loadIncomingBookings();
    } on DioException catch (e) {
      emit(GuideDashboardError(e.response?.data?['message'] ?? 'Failed to update status'));
    }
  }
}
