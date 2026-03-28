import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SurveyRemoteDataSource {
  Future<void> submitSurveyAnswers({required SurveySubmissionModel submission});

  Future<Map<String, Map<String, dynamic>>> getCompletedSurveyAnswersByType({
    required String userId,
    required String surveyType,
  });
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
      final surveyMeta = await _resolveSurveyMeta(submission.surveyId);
      final surveyId = surveyMeta['id']!;
      final surveyType = surveyMeta['survey_type'];
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
        '[SurveySupabaseDataSource] About to persist: survey=${submission.surveyId} resolvedId=$surveyId type=$surveyType answerCount=${submission.answersMap.length} score=${submission.score}',
      );

      if (surveyType == 'onboarding') {
        final existing = await supabaseClient
            .from('survey_responses')
            .select('id')
            .eq('user_id', submission.userId)
            .eq('survey_id', surveyId)
            .order('completed_at', ascending: false)
            .limit(1)
            .maybeSingle();

        final existingId = existing?['id']?.toString();
        if (existingId != null && existingId.isNotEmpty) {
          await supabaseClient
              .from('survey_responses')
              .update(payload)
              .eq('id', existingId);
          debugPrint(
            '[SurveySupabaseDataSource] Updated existing onboarding response id=$existingId survey=${submission.surveyId}',
          );
        } else {
          await supabaseClient.from('survey_responses').insert(payload);
          debugPrint(
            '[SurveySupabaseDataSource] Inserted new onboarding response survey=${submission.surveyId}',
          );
        }
      } else {
        await supabaseClient.from('survey_responses').insert(payload);
      }

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

  @override
  Future<Map<String, Map<String, dynamic>>> getCompletedSurveyAnswersByType({
    required String userId,
    required String surveyType,
  }) async {
    final result = <String, Map<String, dynamic>>{};

    final rows = await supabaseClient
        .from('survey_responses')
        .select('answers, surveys!inner(survey_key, survey_type), completed_at')
        .eq('user_id', userId)
        .eq('surveys.survey_type', surveyType)
        .order('completed_at', ascending: false);

    for (final row in rows) {
      final surveysNode = row['surveys'];
      final surveyKey = (surveysNode is Map<String, dynamic>)
          ? surveysNode['survey_key']?.toString()
          : null;

      if (surveyKey == null ||
          surveyKey.isEmpty ||
          result.containsKey(surveyKey)) {
        continue;
      }

      final answersRaw = row['answers'];
      if (answersRaw is Map<String, dynamic>) {
        result[surveyKey] = Map<String, dynamic>.from(answersRaw);
      } else {
        result[surveyKey] = {};
      }
    }

    return result;
  }

  Future<Map<String, String>> _resolveSurveyMeta(String surveyIdOrKey) async {
    if (_looksLikeUuid(surveyIdOrKey)) {
      final response = await supabaseClient
          .from('surveys')
          .select('id, survey_type')
          .eq('id', surveyIdOrKey)
          .eq('is_active', true)
          .maybeSingle();

      final resolvedId = response?['id']?.toString();
      final surveyType = response?['survey_type']?.toString();
      if (resolvedId == null || resolvedId.isEmpty) {
        throw Exception('Survey not found or inactive for id: $surveyIdOrKey');
      }
      return {'id': resolvedId, 'survey_type': surveyType ?? ''};
    }

    final response = await supabaseClient
        .from('surveys')
        .select('id, survey_type')
        .eq('survey_key', surveyIdOrKey)
        .eq('is_active', true)
        .maybeSingle();

    final resolvedId = response?['id']?.toString();
    final surveyType = response?['survey_type']?.toString();
    if (resolvedId == null || resolvedId.isEmpty) {
      throw Exception('Survey not found or inactive for key: $surveyIdOrKey');
    }

    return {'id': resolvedId, 'survey_type': surveyType ?? ''};
  }

  bool _looksLikeUuid(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(value);
  }
}
