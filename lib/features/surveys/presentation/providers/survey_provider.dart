import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_local_data_source.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_mock_data_source.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_remote_data_source.dart';
import 'package:braves_cog/features/surveys/data/repositories/survey_repository_impl.dart';
import 'package:braves_cog/features/surveys/domain/repositories/survey_repository.dart';
import 'package:braves_cog/features/surveys/domain/usecases/save_survey_result_usecase.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

// Data Sources
final surveyLocalDataSourceProvider = Provider<SurveyLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SurveyLocalDataSourceImpl(prefs);
});

final surveyRemoteDataSourceProvider = Provider<SurveyRemoteDataSource>((ref) {
  // Use mock data source for dev mode, just like Profile feature
  return SurveyMockDataSource();
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

  String _inferType(dynamic value) {
    if (value is bool) return 'boolean';
    if (value is num) return 'number';
    if (value is String) return 'text';
    if (value is List) return 'list';
    if (value is Map) return 'composite';
    return 'unknown';
  }

  Future<void> submitSurvey(String surveyId) async {
    state = state.copyWith(isLoading: true, error: null, isSaved: false);

    final userId = _ref.read(profileProvider).profile.id ?? 'unknown';

    final answersList = state.answers.entries.map((e) {
      return SurveyAnswerModel(
        questionId: e.key,
        type: _inferType(e.value),
        value: e.value,
      );
    }).toList();

    final metadata = {'completedAt': DateTime.now().toUtc().toIso8601String()};

    final submission = SurveySubmissionModel(
      surveyId: surveyId,
      userId: userId,
      metadata: metadata,
      answers: answersList,
    );

    final result = await _saveSurveyResultUseCase(
      SaveSurveyResultParams(submission: submission),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = state.copyWith(isLoading: false, isSaved: true),
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
