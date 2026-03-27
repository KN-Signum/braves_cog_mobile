import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_local_data_source.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_remote_data_source.dart';
import 'package:braves_cog/features/surveys/data/repositories/survey_repository_impl.dart';
import 'package:braves_cog/features/surveys/domain/repositories/survey_repository.dart';
import 'package:braves_cog/features/surveys/domain/usecases/save_survey_result_usecase.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Sources
final surveyLocalDataSourceProvider = Provider<SurveyLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SurveyLocalDataSourceImpl(prefs);
});

final surveyRemoteDataSourceProvider = Provider<SurveyRemoteDataSource>((ref) {
  return SurveySupabaseDataSource(supabaseClient: Supabase.instance.client);
});

// Repository
final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  final localDS = ref.watch(surveyLocalDataSourceProvider);
  final remoteDS = ref.watch(surveyRemoteDataSourceProvider);
  return SurveyRepositoryImpl(
    localDataSource: localDS,
    remoteDataSource: remoteDS,
  );
});

// Use Cases
final saveSurveyResultUseCaseProvider = Provider<SaveSurveyResultUseCase>((
  ref,
) {
  return SaveSurveyResultUseCase(ref.watch(surveyRepositoryProvider));
});

// State
class SurveyState {
  final Map<String, dynamic> answers;
  final bool isLoading;
  final String? error;
  final bool isSaved;

  const SurveyState({
    this.answers = const {},
    this.isLoading = false,
    this.error,
    this.isSaved = false,
  });

  SurveyState copyWith({
    Map<String, dynamic>? answers,
    bool? isLoading,
    String? error,
    bool? isSaved,
  }) {
    return SurveyState(
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

// Notifier
class SurveyNotifier extends StateNotifier<SurveyState> {
  final SaveSurveyResultUseCase _saveSurveyResultUseCase;
  final Ref _ref;

  SurveyNotifier(this._saveSurveyResultUseCase, this._ref)
    : super(const SurveyState());

  void setInitialAnswers(Map<String, dynamic>? initialAnswers) {
    if (initialAnswers != null) {
      state = state.copyWith(answers: initialAnswers);
    } else {
      state = state.copyWith(answers: {});
    }
  }

  void updateAnswer(String key, dynamic value) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[key] = value;
    state = state.copyWith(answers: newAnswers);
  }

  void removeAnswer(String key) {
    if (state.answers.containsKey(key)) {
      final newAnswers = Map<String, dynamic>.from(state.answers);
      newAnswers.remove(key);
      state = state.copyWith(answers: newAnswers);
    }
  }

  int? _calculateScore(String surveyId, Map<String, dynamic> answers) {
    int getIntAnswer(String key) {
      final value = answers[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
      return 0;
    }

    // PHQ-2
    if (surveyId == 'PHQ_2') {
      return getIntAnswer('phq2_1') + getIntAnswer('phq2_2');
    }

    // GAD-2
    if (surveyId == 'GAD_2') {
      return getIntAnswer('gad2_1') + getIntAnswer('gad2_2');
    }

    // PHQ-9
    if (surveyId == 'Baseline_Depression' ||
        surveyId.contains('PHQ_9') ||
        surveyId.contains('phq9')) {
      int score = 0;
      for (int i = 1; i <= 9; i++) {
        score += getIntAnswer('phq9_$i');
      }
      return score;
    }

    // GAD-7
    if (surveyId == 'Baseline_Stress_And_Anxiety_GAD7' ||
        surveyId.contains('GAD_7') ||
        surveyId.contains('gad7')) {
      int score = 0;
      for (int i = 1; i <= 7; i++) {
        score += getIntAnswer('gad7_$i');
      }
      return score;
    }

    // AQ
    if (surveyId == 'Baseline_ASD' ||
        surveyId == 'followup_AQ' ||
        surveyId.contains('AQ') ||
        surveyId.contains('aq')) {
      int score = 0;
      for (int i = 1; i <= 50; i++) {
        score += getIntAnswer('aq_$i');
      }
      return score;
    }

    return null;
  }

  Future<void> submitSurvey(String surveyId) async {
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    final authState = _ref.read(authProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Brak zalogowanego użytkownika. Nie można wysłać ankiety.',
      );
      return;
    }

    final score = _calculateScore(surveyId, state.answers);

    debugPrint(
      '[SurveyNotifier] submitSurvey surveyId=$surveyId answers=${state.answers.length} score=$score',
    );

    final metadata = {'completedAt': DateTime.now().toUtc().toIso8601String()};

    final submission = SurveySubmissionModel(
      surveyId: surveyId,
      userId: userId,
      answersMap: state.answers,
      score: score,
      metadata: metadata,
    );

    final result = await _saveSurveyResultUseCase(
      SaveSurveyResultParams(submission: submission),
    );

    result.fold(
      (failure) {
        debugPrint(
          '[SurveyNotifier] Submission failed for $surveyId: ${failure.message}',
        );
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        debugPrint('[SurveyNotifier] Submission successful for: $surveyId');
        state = state.copyWith(isLoading: false, isSaved: true);
      },
    );
  }
}

final surveyProvider =
    StateNotifierProvider.family<SurveyNotifier, SurveyState, String>((
      ref,
      surveyId,
    ) {
      // Family provider so each active survey has its isolated state if needed
      final saveUseCase = ref.watch(saveSurveyResultUseCaseProvider);
      return SurveyNotifier(saveUseCase, ref);
    });
