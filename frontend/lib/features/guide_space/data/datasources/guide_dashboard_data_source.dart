import 'package:dio/dio.dart';

class GuideDashboardDataSource {
  GuideDashboardDataSource(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> loadDashboard() async {
    final response = await _dio.get('/guide/dashboard');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> loadIncomingBookings() async {
    final response = await _dio.get('/bookings/incoming');
    return response.data['data'] as List;
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    await _dio.patch('/bookings/$bookingId/status', data: {'status': status});
  }
}
