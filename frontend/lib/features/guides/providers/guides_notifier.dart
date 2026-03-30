import 'package:dio/dio.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';
import 'package:guideme/features/guides/domain/repositories/guides_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuidesState {
  final List<GuideEntity> guides;
  final bool isLoading;
  final String? error;

  const GuidesState({
    this.guides = const [],
    this.isLoading = false,
    this.error,
  });

  GuidesState copyWith({
    List<GuideEntity>? guides,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      GuidesState(
        guides: guides ?? this.guides,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
      );
}

class GuidesNotifier extends StateNotifier<GuidesState> {
  GuidesNotifier(this._repository) : super(const GuidesState()) {
    fetchGuides();
  }

  final IGuidesRepository _repository;

  Future<void> fetchGuides() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final guides = await _repository.fetchAllGuides();
      state = state.copyWith(guides: guides, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _netError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchGuides({
    String? city,
    double? minBudget,
    double? maxBudget,
    String? language,
    bool? transportAvailable,
    double? minRating,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final guides = await _repository.searchGuides(
        city: city,
        minBudget: minBudget,
        maxBudget: maxBudget,
        language: language,
        transportAvailable: transportAvailable,
        minRating: minRating,
      );
      state = state.copyWith(guides: guides, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _netError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
