import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/save_test_result_usecase.dart';

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

  Future<void> saveResult(CognitiveTestResult result) async {
    debugPrint('📊 [CognitiveGamesNotifier] saveResult() Called');
    debugPrint('📊 [CognitiveGamesNotifier] Test: ${result.testType}');

    // 1. Zaczynamy ładowanie
    debugPrint('📊 [CognitiveGamesNotifier] Ustawianie isLoading = true');
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    // 2. Wywołujemy Use Case
    debugPrint('📊 [CognitiveGamesNotifier] Wysyłanie do Use Case...');
    final response = await _saveTestResultUseCase(result);

    // 3. Rozpakowujemy wynik z Either (Left = błąd, Right = sukces)
    response.fold(
      (failure) {
        debugPrint('❌ [CognitiveGamesNotifier] Błąd: ${failure.message}');
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        debugPrint('✅ [CognitiveGamesNotifier] Sukces! Wynik zapisany');
        state = state.copyWith(isLoading: false, isSaved: true);
      },
    );
  }
}
