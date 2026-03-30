import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/guides/data/datasources/guides_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/guides/presentation/cubit/guides_state.dart';

class GuidesCubit extends Cubit<GuidesState> {
  GuidesCubit(this._dataSource) : super(GuidesInitial());
  final GuidesRemoteDataSource _dataSource;

  void fetchGuides() async {
    emit(GuidesLoading());
    try {
      final guides = await _dataSource.fetchAllGuides();
      emit(GuidesLoaded(guides));
    } on DioException catch (e) {
      emit(GuidesError(_netError(e)));
    } catch (e) {
      emit(GuidesError(e.toString()));
    }
  }

  void searchGuides({
    String? city, double? minBudget, double? maxBudget,
    String? language, bool? transportAvailable, double? minRating,
  }) async {
    emit(GuidesLoading());
    try {
      final guides = await _dataSource.searchGuides(
        city: city, minBudget: minBudget, maxBudget: maxBudget,
        language: language, transportAvailable: transportAvailable, minRating: minRating,
      );
      emit(GuidesLoaded(guides));
    } on DioException catch (e) {
      emit(GuidesError(_netError(e)));
    } catch (e) {
      emit(GuidesError(e.toString()));
    }
  }

  String _netError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'Cannot reach server. Make sure Spring Boot is running on port 8081.';
    }
    return e.response?.data?['message'] ?? 'An error occurred';
  }
}
