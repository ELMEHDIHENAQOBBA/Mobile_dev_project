import 'package:dio/dio.dart';
import 'package:guideme/features/booking/domain/entities/booking_entity.dart';

class BookingRemoteDataSource {
  BookingRemoteDataSource(this._dio);
  final Dio _dio;

  Future<BookingEntity> createBooking({
    required int guideId, required String visitDate,
    required int durationHours, required int numberOfPeople,
    String? specialRequest,
  }) async {
    final response = await _dio.post('/bookings', data: {
      'guideId': guideId, 'visitDate': visitDate,
      'durationHours': durationHours, 'numberOfPeople': numberOfPeople,
      if (specialRequest != null) 'specialRequest': specialRequest,
    });
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<BookingEntity>> getMyBookings() async {
    final response = await _dio.get('/bookings/me');
    return (response.data['data'] as List)
        .map((e) => _fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BookingEntity> updateStatus(int bookingId, String status, {String? reason}) async {
    final response = await _dio.patch('/bookings/$bookingId/status', data: {
      'status': status,
      if (reason != null) 'cancellationReason': reason,
    });
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  BookingEntity _fromJson(Map<String, dynamic> j) => BookingEntity(
        id: j['id'] as int,
        guideId: j['guideId'] as int,
        guideName: j['guideName'] as String,
        guideProfileImage: j['guideProfileImage'] as String? ?? '',
        guideCity: j['guideCity'] as String,
        visitDate: j['visitDate'] as String,
        durationHours: j['durationHours'] as int,
        numberOfPeople: j['numberOfPeople'] as int,
        specialRequest: j['specialRequest'] as String?,
        totalPrice: (j['totalPrice'] as num).toDouble(),
        status: j['status'] as String,
        cancelledBy: j['cancelledBy'] as String?,
        cancellationReason: j['cancellationReason'] as String?,
        createdAt: j['createdAt'] as String,
      );
}
