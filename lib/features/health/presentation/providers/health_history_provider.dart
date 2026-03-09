import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/domain/usecases/get_health_history_usecase.dart';
import 'package:braves_cog/features/health/presentation/providers/health_form_provider.dart';

final getHealthHistoryUseCaseProvider = Provider<GetHealthHistoryUseCase>((ref) {
  return GetHealthHistoryUseCase(ref.watch(healthRepositoryProvider));
});

class HealthHistoryState {
  final List<HealthDataEntity> history;
  final bool isLoading;
  final String? error;

  const HealthHistoryState({
    this.history = const [],
    this.isLoading = false,
    this.error,
  });

  HealthHistoryState copyWith({
    List<HealthDataEntity>? history,
    bool? isLoading,
    String? error,
  }) {
    return HealthHistoryState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HealthHistoryNotifier extends StateNotifier<HealthHistoryState> {
  final GetHealthHistoryUseCase _getHealthHistoryUseCase;

  HealthHistoryNotifier(this._getHealthHistoryUseCase) : super(const HealthHistoryState());

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _getHealthHistoryUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (history) => state = state.copyWith(isLoading: false, history: history),
    );
  }
}

final healthHistoryProvider = StateNotifierProvider<HealthHistoryNotifier, HealthHistoryState>((ref) {
  final useCase = ref.watch(getHealthHistoryUseCaseProvider);
  return HealthHistoryNotifier(useCase);
});
