import 'package:dio/dio.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';

class GuidesRemoteDataSource {
  GuidesRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<GuideEntity>> fetchAllGuides() async {
    final response = await _dio.get('/guides');
    return _parseList(response);
  }

  Future<List<GuideEntity>> searchGuides({
    String? city, double? minBudget, double? maxBudget,
    String? language, bool? transportAvailable, double? minRating,
  }) async {
    final params = <String, dynamic>{};
    if (city != null && city.isNotEmpty && city != 'All') params['city'] = city;
    if (minBudget != null) params['minBudget'] = minBudget;
    if (maxBudget != null) params['maxBudget'] = maxBudget;
    if (language != null && language.isNotEmpty && language != 'All') params['language'] = language;
    if (transportAvailable == true) params['transportAvailable'] = true;
    if (minRating != null) params['minRating'] = minRating;
    final response = await _dio.get('/guides', queryParameters: params);
    return _parseList(response);
  }

  Future<GuideEntity> getGuideById(int id) async {
    final response = await _dio.get('/guides/$id');
    return _fromJson(response.data['data'] as Map<String, dynamic>);
  }

  List<GuideEntity> _parseList(Response r) =>
      (r.data['data'] as List).map((e) => _fromJson(e as Map<String, dynamic>)).toList();

  GuideEntity _fromJson(Map<String, dynamic> j) => GuideEntity(
        id: j['id'] as int,
        name: j['name'] as String,
        languages: List<String>.from(j['languages'] as List),
        priceMin: (j['priceMin'] as num).toDouble(),
        priceMax: (j['priceMax'] as num).toDouble(),
        rating: (j['rating'] as num).toDouble(),
        city: j['city'] as String,
        transportAvailable: j['transportAvailable'] as bool,
        description: j['description'] as String,
        profileImage: j['profileImage'] as String? ?? '',
        reviewsCount: j['reviewsCount'] as int,
      );
}
