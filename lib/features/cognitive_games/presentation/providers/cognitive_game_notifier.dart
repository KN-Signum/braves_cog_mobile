import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/save_test_result_usecase.dart';

// ─── RESULT TYPE ───
class SaveSequenceResultWithFeedback {
  final bool success;
  final String? errorMessage;
  final int savedCount;
  final int failedCount;
  final List<String> failedTests;

  SaveSequenceResultWithFeedback({
    required this.success,
    this.errorMessage,
    this.savedCount = 0,
    this.failedCount = 0,
    List<String>? failedTests,
  }) : failedTests = failedTests ?? [];
}

// --- STATE ---
class CognitiveGamesState {
  final bool isLoading;
  final String? error;
  final bool isSaved;

  const CognitiveGamesState({
    this.isLoading = false,
    this.error,
    this.isSaved = false,
  });

  CognitiveGamesState copyWith({
    bool? isLoading,
    String? error,
    bool? isSaved,
  }) {
    return CognitiveGamesState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

// --- NOTIFIER ---
class CognitiveGamesNotifier extends StateNotifier<CognitiveGamesState> {
  final SaveTestResultUseCase _saveTestResultUseCase;

  CognitiveGamesNotifier(this._saveTestResultUseCase)
    : super(const CognitiveGamesState());

  /// Metoda do zapisywania pojedynczego wyniku (dla kompatybilności wstecznej)
  Future<void> saveResult(CognitiveTestResult result) async {
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    final response = await _saveTestResultUseCase(result);

    response.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = state.copyWith(isLoading: false, isSaved: true),
    );
  }

  /// Original all-or-nothing batch save
  Future<bool> saveSequenceResults(List<CognitiveTestResult> results) async {
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    try {
      for (final result in results) {
        final response = await _saveTestResultUseCase(result);

        if (response.isLeft()) {
          final errorMessage = response.fold(
            (failure) => failure.message,
            (_) => 'Nieznany błąd',
          );

          state = state.copyWith(isLoading: false, error: errorMessage);
          return false; // Wyjście z funkcji przy pierwszym błędzie
        }
      }

      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// New method: Allows partial saves, returns detailed feedback
  Future<SaveSequenceResultWithFeedback> saveSequenceResultsWithFeedback(
    List<CognitiveTestResult> results,
  ) async {
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    int savedCount = 0;
    int failedCount = 0;
    final List<String> failedTests = [];

    try {
      // Attempt to save each result individually
      for (final result in results) {
        try {
          final response = await _saveTestResultUseCase(result);

          if (response.isRight()) {
            savedCount++;
            debugPrint('✅ [CognitiveGamesNotifier] Saved: ${result.testType}');
          } else {
            failedCount++;
            failedTests.add(result.testType.toString());
            final errorMsg = response.fold(
              (failure) => failure.message,
              (_) => 'Nieznany błąd',
            );
            debugPrint(
              '❌ [CognitiveGamesNotifier] Failed to save ${result.testType}: $errorMsg',
            );
          }
        } catch (e) {
          failedCount++;
          failedTests.add(result.testType.toString());
          debugPrint(
            '❌ [CognitiveGamesNotifier] Exception saving ${result.testType}: $e',
          );
        }
      }

      // Determine overall success
      final overallSuccess = savedCount > 0 && failedCount == 0;

      if (overallSuccess) {
        state = state.copyWith(isLoading: false, isSaved: true);
        return SaveSequenceResultWithFeedback(
          success: true,
          savedCount: savedCount,
          failedCount: failedCount,
        );
      } else if (savedCount > 0 && failedCount > 0) {
        // Partial success
        final errorMessage =
            'Zapisano $savedCount z ${results.length} testów. Błędy: ${failedTests.join(", ")}';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return SaveSequenceResultWithFeedback(
          success: true, // Consider partial success as acceptable
          errorMessage: errorMessage,
          savedCount: savedCount,
          failedCount: failedCount,
          failedTests: failedTests,
        );
      } else {
        // Complete failure
        final errorMessage = 'Nie udało się zapisać żadnych testów';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return SaveSequenceResultWithFeedback(
          success: false,
          errorMessage: errorMessage,
          savedCount: 0,
          failedCount: failedCount,
          failedTests: failedTests,
        );
      }
    } catch (e) {
      final errorMessage = 'Krytyczny błąd: $e';
      state = state.copyWith(isLoading: false, error: errorMessage);
      return SaveSequenceResultWithFeedback(
        success: false,
        errorMessage: errorMessage,
        failedCount: results.length,
        failedTests: results.map((r) => r.testType.toString()).toList(),
      );
    }
  }
}
