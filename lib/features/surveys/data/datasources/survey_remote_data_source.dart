import 'package:braves_cog/features/surveys/config/survey_schedule_config.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SurveyRemoteDataSource {
  Future<void> submitSurveyAnswers({required SurveySubmissionModel submission});

  Future<Map<String, Map<String, dynamic>>> getCompletedSurveyAnswersByType({
    required String userId,
    required String surveyType,
  });

  Future<bool> isFlowCompletedToday({
    required String userId,
    required String flowType, // 'screening' or 'followup'
  });

  /// Check if user has started any surveys in the given flow today.
  /// Returns true if there are any responses for this flow submitted today.
  Future<bool> isFlowStartedToday({
    required String userId,
    required String flowType,
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

      // Allow empty answers for onboarding and screening flows
      // (these have info/intro screens with no user input)
      final flowsAllowingEmptyAnswers = {'onboarding', 'screening'};
      if (submission.answersMap.isEmpty &&
          !flowsAllowingEmptyAnswers.contains(surveyType)) {
        debugPrint(
          '[SurveySupabaseDataSource] Skip empty payload for non-onboarding survey=${submission.surveyId}',
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

  @override
  Future<bool> isFlowCompletedToday({
    required String userId,
    required String flowType,
  }) async {
    try {
      debugPrint(
        '[SurveySupabaseDataSource] START isFlowCompletedToday userId=$userId flowType=$flowType',
      );

      // Get required survey list for the flow type
      final requiredSurveys = _getRequiredSurveysForType(flowType);
      if (requiredSurveys.isEmpty) {
        debugPrint(
          '[SurveySupabaseDataSource] No required surveys found for flowType=$flowType',
        );
        return false;
      }

      // Get today's date range
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(Duration(days: 1));
      final todayStart = today.toUtc().toIso8601String();
      final tomorrowStart = tomorrow.toUtc().toIso8601String();

      // Query all survey_responses for this user, today, of the given type
      final rows = await supabaseClient
          .from('survey_responses')
          .select('surveys!inner(survey_key)')
          .eq('user_id', userId)
          .eq('surveys.survey_type', flowType)
          .gte('completed_at', todayStart)
          .lt('completed_at', tomorrowStart);

      // Extract all survey_keys from the responses
      final submittedKeys = <String>{};
      for (final row in rows) {
        final surveysNode = row['surveys'];
        final surveyKey = (surveysNode is Map<String, dynamic>)
            ? surveysNode['survey_key']?.toString()
            : null;

        if (surveyKey != null && surveyKey.isNotEmpty) {
          submittedKeys.add(surveyKey);
        }
      }

      debugPrint(
        '[SurveySupabaseDataSource] Found ${submittedKeys.length} unique submitted surveys for flowType=$flowType',
      );

      // Check if ALL required surveys have been submitted
      final allRequired = Set<String>.from(requiredSurveys);
      final isComplete = allRequired.every(
        (key) => submittedKeys.contains(key),
      );

      debugPrint(
        '[SurveySupabaseDataSource] isFlowCompletedToday: required=${allRequired.length} submitted=${submittedKeys.length} complete=$isComplete',
      );

      return isComplete;
    } catch (e, stackTrace) {
      debugPrint(
        '[SurveySupabaseDataSource] ERROR in isFlowCompletedToday: $e\n$stackTrace',
      );
      return false;
    }
  }

  @override
  Future<bool> isFlowStartedToday({
    required String userId,
    required String flowType,
  }) async {
    try {
      debugPrint(
        '[SurveySupabaseDataSource] START isFlowStartedToday userId=$userId flowType=$flowType',
      );

      // Get today's date range
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(Duration(days: 1));
      final todayStart = today.toUtc().toIso8601String();
      final tomorrowStart = tomorrow.toUtc().toIso8601String();

      // Query ANY survey_response for this user today in this flow
      // Must include surveys relationship in select to filter by surveys.survey_type
      final rows = await supabaseClient
          .from('survey_responses')
          .select('id, surveys!inner(id)')
          .eq('user_id', userId)
          .eq('surveys.survey_type', flowType)
          .gte('completed_at', todayStart)
          .lt('completed_at', tomorrowStart)
          .limit(1);

      final hasResponses = rows.isNotEmpty;

      debugPrint(
        '[SurveySupabaseDataSource] isFlowStartedToday flowType=$flowType hasResponses=$hasResponses',
      );

      return hasResponses;
    } catch (e, stackTrace) {
      debugPrint(
        '[SurveySupabaseDataSource] ERROR in isFlowStartedToday: $e\n$stackTrace',
      );
      return false;
    }
  }

  List<String> _getRequiredSurveysForType(String flowType) {
    if (flowType == SurveyScheduleConfig.screening) {
      return SurveyScheduleConfig.screeningSurveyKeys;
    } else if (flowType == SurveyScheduleConfig.followUp) {
      return SurveyScheduleConfig.followUpSurveyKeys;
    }
    return [];
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
