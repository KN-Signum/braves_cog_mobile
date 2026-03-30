import 'dart:convert';
import 'dart:io';

import 'package:braves_cog/features/surveys/data/datasources/survey_remote_data_source.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:path_provider/path_provider.dart';

class SurveyMockDataSource implements SurveyRemoteDataSource {
  @override
  Future<void> submitSurveyAnswers({
    required SurveySubmissionModel submission,
  }) async {
    // Simulate network delay for dev mode
    await Future.delayed(const Duration(seconds: 1));

    // Save response answers to actual json file for debugging
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().toIso8601String().replaceAll(
        ':',
        '-',
      );
      final File file = File(
        '${directory.path}/survey_${submission.surveyId}_$timestamp.json',
      );

      final String jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(submission.toJson());
      await file.writeAsString(jsonString);

      print(
        'DEBUG: Saved survey ${submission.surveyId} answers to ${file.path}',
      );
    } catch (e) {
      print('DEBUG: Error saving survey ${submission.surveyId} answers: $e');
    }

    // In a real scenario, this would post to an API endpoint.
    // For now we just return success.
    return;
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getCompletedSurveyAnswersByType({
    required String userId,
    required String surveyType,
  }) async {
    // Mock datasource: no persisted remote progress; return empty set.
    return <String, Map<String, dynamic>>{};
  }

  @override
  Future<bool> isFlowCompletedToday({
    required String userId,
    required String flowType,
  }) async {
    // Mock datasource: never complete; always allow resume
    return false;
  }
}
