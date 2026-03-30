class BookingEntity {
  final int id;
  final int guideId;
  final String guideName;
  final String guideProfileImage;
  final String guideCity;
  final String visitDate;
  final int durationHours;
  final int numberOfPeople;
  final String? specialRequest;
  final double totalPrice;
  final String status;
  final String? cancelledBy;
  final String? cancellationReason;
  final String createdAt;

  const BookingEntity({
    required this.id, required this.guideId, required this.guideName,
    required this.guideProfileImage, required this.guideCity,
    required this.visitDate, required this.durationHours,
    required this.numberOfPeople, this.specialRequest,
    required this.totalPrice, required this.status,
    this.cancelledBy, this.cancellationReason, required this.createdAt,
  });

  bool get isPending => status == 'PENDING';
  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';
}
