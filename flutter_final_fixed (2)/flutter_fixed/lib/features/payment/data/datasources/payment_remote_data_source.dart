import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/features/payment/domain/entities/payment_entity.dart';

class PaymentRemoteDataSource {
  PaymentRemoteDataSource(this._dio);
  final Dio _dio;

  Future<PaymentEntity> processPayment(int bookingId) async {
    final response = await _dio.post('/payments/booking/$bookingId');
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<PaymentEntity> getPaymentByBooking(int bookingId) async {
    final response = await _dio.get('/payments/booking/$bookingId');
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  PaymentEntity _fromJson(Map<String, dynamic> j) => PaymentEntity(
        id: j['id'] as int,
        bookingId: j['bookingId'] as int,
        amount: (j['amount'] as num).toDouble(),
        status: j['status'] as String,
        paymentMethod: j['paymentMethod'] as String,
        transactionRef: j['transactionRef'] as String,
        createdAt: j['createdAt'] as String,
        paidAt: j['paidAt'] as String?,
      );
}
