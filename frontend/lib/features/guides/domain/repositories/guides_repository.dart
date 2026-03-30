import 'package:guideme/features/guides/domain/entities/guide_entity.dart';

abstract interface class IGuidesRepository {
  Future<List<GuideEntity>> fetchAllGuides();
  Future<List<GuideEntity>> searchGuides({
    String? city,
    double? minBudget,
    double? maxBudget,
    String? language,
    bool? transportAvailable,
    double? minRating,
  });
}
