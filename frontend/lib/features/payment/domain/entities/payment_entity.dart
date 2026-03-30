class PaymentEntity {
  final int id;
  final int bookingId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String transactionRef;
  final String createdAt;
  final String? paidAt;

  const PaymentEntity({
    required this.id, required this.bookingId, required this.amount,
    required this.status, required this.paymentMethod,
    required this.transactionRef, required this.createdAt, this.paidAt,
  });

  bool get isPaid => status == 'PAID';
}
