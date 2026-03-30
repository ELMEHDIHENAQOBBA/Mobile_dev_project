import 'package:guideme/features/guides/data/datasources/guides_remote_data_source.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';
import 'package:guideme/features/guides/domain/repositories/guides_repository.dart';

class GuidesRepositoryImpl implements IGuidesRepository {
  GuidesRepositoryImpl(this._dataSource);
  final GuidesRemoteDataSource _dataSource;

  @override
  Future<List<GuideEntity>> fetchAllGuides() => _dataSource.fetchAllGuides();

  @override
  Future<List<GuideEntity>> searchGuides({
    String? city,
    double? minBudget,
    double? maxBudget,
    String? language,
    bool? transportAvailable,
    double? minRating,
  }) =>
      _dataSource.searchGuides(
        city: city,
        minBudget: minBudget,
        maxBudget: maxBudget,
        language: language,
        transportAvailable: transportAvailable,
        minRating: minRating,
      );
}
