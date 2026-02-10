import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/core/config/env_config.dart';
import 'package:braves_cog/features/health/data/datasources/health_local_data_source.dart';
import 'package:braves_cog/features/health/data/datasources/health_mock_data_source.dart';
import 'package:braves_cog/features/health/data/datasources/health_remote_data_source.dart';
import 'package:braves_cog/features/health/data/repositories/health_repository_impl.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/domain/repositories/health_repository.dart';
import 'package:braves_cog/features/health/domain/usecases/save_health_data_usecase.dart';

// --- Dependency Injection ---

final healthLocalDataSourceProvider = Provider<HealthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HealthLocalDataSourceImpl(sharedPreferences: prefs);
});

final healthRemoteDataSourceProvider = Provider<HealthRemoteDataSource>((ref) {
  if (EnvConfig.useMockData) {
    return HealthMockDataSource();
  }
  // Ideally implement real remote data source
  return HealthMockDataSource(); 
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(
    remoteDataSource: ref.watch(healthRemoteDataSourceProvider),
    localDataSource: ref.watch(healthLocalDataSourceProvider),
  );
});

final saveHealthDataUseCaseProvider = Provider<SaveHealthDataUseCase>((ref) {
  return SaveHealthDataUseCase(ref.watch(healthRepositoryProvider));
});

// --- State Management ---

class HealthFormState {
  final HealthDataEntity data;
  final int currentStep;
  final bool isSubmitting;
  final String? error;

  const HealthFormState({
    this.data = const HealthDataEntity(),
    this.currentStep = 0,
    this.isSubmitting = false,
    this.error,
  });

  HealthFormState copyWith({
    HealthDataEntity? data,
    int? currentStep,
    bool? isSubmitting,
    String? error,
  }) {
    return HealthFormState(
      data: data ?? this.data,
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class HealthFormNotifier extends StateNotifier<HealthFormState> {
  final SaveHealthDataUseCase _saveHealthDataUseCase;

  HealthFormNotifier(this._saveHealthDataUseCase) : super(const HealthFormState());

  void updateData(HealthDataEntity newData) {
    state = state.copyWith(data: newData);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, error: null);
    
    final result = await _saveHealthDataUseCase(state.data);
    
    result.fold(
      (failure) => state = state.copyWith(isSubmitting: false, error: failure.message),
      (_) => state = state.copyWith(isSubmitting: false),
    );
  }
}

final healthFormProvider = StateNotifierProvider<HealthFormNotifier, HealthFormState>((ref) {
  final saveUseCase = ref.watch(saveHealthDataUseCaseProvider);
  return HealthFormNotifier(saveUseCase);
});
