import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SurveyLocalDataSource {
  Future<void> cacheSurveyAnswers(
    String surveyId,
    Map<String, dynamic> answers,
  );
  Future<Map<String, dynamic>?> getCachedSurveyAnswers(String surveyId);
}

class SurveyLocalDataSourceImpl implements SurveyLocalDataSource {
  final SharedPreferences prefs;

  SurveyLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheSurveyAnswers(
    String surveyId,
    Map<String, dynamic> answers,
  ) async {
    final key = 'survey_cache_$surveyId';
    await prefs.setString(key, jsonEncode(answers));
  }

  @override
  Future<Map<String, dynamic>?> getCachedSurveyAnswers(String surveyId) async {
    final key = 'survey_cache_$surveyId';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
