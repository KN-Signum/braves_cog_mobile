import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
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

  Future<bool> saveSequenceResults(List<CognitiveTestResult> results) async {
    // 1. Resetujemy stan i włączamy loader
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    try {
      // 2. Iterujemy przez wszystkie wyniki
      for (final result in results) {
        final response = await _saveTestResultUseCase(result);

        // 3. Sprawdzamy czy wystąpił błąd (Left)
        // Jeśli tak - przerywamy pętlę i zwracamy błąd użytkownikowi
        if (response.isLeft()) {
          final errorMessage = response.fold(
            (failure) => failure.message,
            (_) => 'Nieznany błąd',
          );

          state = state.copyWith(isLoading: false, error: errorMessage);
          return false; // Wyjście z funkcji przy pierwszym błędzie
        }
      }

      // 4. Jeśli pętla przeszła bez błędów -> Sukces
      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      // Zabezpieczenie na wypadek nieoczekiwanych wyjątków spoza Either
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
