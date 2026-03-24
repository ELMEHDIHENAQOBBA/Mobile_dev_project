class ReviewEntity {
  final int id;
  final int guideId;
  final int touristId;
  final String touristName;
  final int bookingId;
  final int rating;
  final String? comment;
  final String createdAt;

  const ReviewEntity({
    required this.id, required this.guideId, required this.touristId,
    required this.touristName, required this.bookingId,
    required this.rating, this.comment, required this.createdAt,
  });
}
