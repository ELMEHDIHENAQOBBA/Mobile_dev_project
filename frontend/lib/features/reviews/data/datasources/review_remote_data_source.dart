import 'package:dio/dio.dart';
import 'package:guideme/features/reviews/domain/entities/review_entity.dart';

class ReviewRemoteDataSource {
  ReviewRemoteDataSource(this._dio);
  final Dio _dio;

  Future<ReviewEntity> createReview({
    required int bookingId, required int guideId,
    required int rating, String? comment,
  }) async {
    final response = await _dio.post('/reviews', data: {
      'bookingId': bookingId, 'guideId': guideId,
      'rating': rating, if (comment != null) 'comment': comment,
    });
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<ReviewEntity>> getGuideReviews(int guideId) async {
    final response = await _dio.get('/guides/$guideId/reviews');
    return (response.data['data'] as List)
        .map((e) => _fromJson(e as Map<String, dynamic>))
        .toList();
  }

  ReviewEntity _fromJson(Map<String, dynamic> j) => ReviewEntity(
        id: j['id'] as int,
        guideId: j['guideId'] as int,
        touristId: j['touristId'] as int,
        touristName: j['touristName'] as String,
        bookingId: j['bookingId'] as int,
        rating: j['rating'] as int,
        comment: j['comment'] as String?,
        createdAt: j['createdAt'] as String,
      );
}
