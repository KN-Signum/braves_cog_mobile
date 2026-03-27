import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SurveyRemoteDataSource {
  Future<void> submitSurveyAnswers({required SurveySubmissionModel submission});
}

class SurveySupabaseDataSource implements SurveyRemoteDataSource {
  final SupabaseClient supabaseClient;

  SurveySupabaseDataSource({required this.supabaseClient});

  @override
  Future<void> submitSurveyAnswers({
    required SurveySubmissionModel submission,
  }) async {
    debugPrint(
      '[SurveySupabaseDataSource] START submitSurveyAnswers for survey=${submission.surveyId} userId=${submission.userId}',
    );

    try {
      final surveyId = await _resolveSurveyId(submission.surveyId);
      debugPrint(
        '[SurveySupabaseDataSource] Resolved surveyId=$surveyId for key=${submission.surveyId}',
      );

      final completedAt =
          submission.metadata['completedAt']?.toString() ??
          DateTime.now().toUtc().toIso8601String();

      if (submission.answersMap.isEmpty) {
        debugPrint(
          '[SurveySupabaseDataSource] Skip empty payload for survey=${submission.surveyId}',
        );
        return;
      }

      // Single row with JSON answers object
      final payload = {
        'user_id': submission.userId,
        'survey_id': surveyId,
        'answers': submission.answersMap,
        'score': submission.score,
        'completed_at': completedAt,
      };

      debugPrint(
        '[SurveySupabaseDataSource] About to insert: survey=${submission.surveyId} resolvedId=$surveyId answerCount=${submission.answersMap.length} score=${submission.score}',
      );

      await supabaseClient.from('survey_responses').insert(payload);
      debugPrint(
        '[SurveySupabaseDataSource] Upload success survey=${submission.surveyId}',
      );
    } catch (e, stackTrace) {
      debugPrint('[SurveySupabaseDataSource] ERROR: $e\n$stackTrace');
      throw Exception(
        'Survey submission failed for survey=${submission.surveyId}: $e',
      );
    }
  }

  Future<String> _resolveSurveyId(String surveyIdOrKey) async {
    if (_looksLikeUuid(surveyIdOrKey)) {
      return surveyIdOrKey;
    }

    final response = await supabaseClient
        .from('surveys')
        .select('id')
        .eq('survey_key', surveyIdOrKey)
        .eq('is_active', true)
        .maybeSingle();

    final resolvedId = response?['id']?.toString();
    if (resolvedId == null || resolvedId.isEmpty) {
      throw Exception('Survey not found or inactive for key: $surveyIdOrKey');
    }

    return resolvedId;
  }

  bool _looksLikeUuid(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(value);
  }
}
