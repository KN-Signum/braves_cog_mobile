import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class SurveyValidationManager {
  static bool canProceed(
    SurveyQuestionEntity question,
    Map<String, dynamic> answers,
  ) {
    if (question.options?['info'] == true) {
      return true;
    }

    if (!question.required) return true;

    if (question.type == QuestionType.table) {
      return _validateTableQuestion(question, answers);
    }

    if (question.options?['composite'] != null) {
      return _validateCompositeQuestion(question, answers);
    }

    if (!answers.containsKey(question.id)) return false;

    final answer = answers[question.id];
    if (answer == null) return false;

    if (answer is String && answer.isEmpty) return false;
    if (answer is List && answer.isEmpty) return false;

    return true;
  }

  static bool _validateTableQuestion(
    SurveyQuestionEntity question,
    Map<String, dynamic> answers,
  ) {
    final rows = question.options?['rows'] as List<dynamic>? ?? [];

    for (var row in rows) {
      final rowKey = row is Map ? row['value'] : row.toString();
      final answerKey = '${question.id}_$rowKey';
      if (!answers.containsKey(answerKey) || answers[answerKey] == null) {
        return false;
      }
    }

    return true;
  }

  static bool _validateCompositeQuestion(
    SurveyQuestionEntity question,
    Map<String, dynamic> answers,
  ) {
    final compositeType = question.options?['composite'];

    if (compositeType == 'doctor_visit') {
      final doctorVisited = answers[question.id];
      if (doctorVisited == true) {
        final specialization = answers['${question.id}_specialization'];
        final newDiagnosis = answers['${question.id}_new_diagnosis'];
        if (specialization == null || specialization.toString().isEmpty) {
          return false;
        }
        if (newDiagnosis == true) {
          final diagnosisDesc = answers['${question.id}_new_diagnosis_desc'];
          if (diagnosisDesc == null || diagnosisDesc.toString().isEmpty) {
            return false;
          }
        }
      }
      return true;
    }

    if (compositeType == 'medications') {
      final medsChanged = answers[question.id];
      if (medsChanged == true) {
        final medications = answers['${question.id}_medications'] as List?;
        if (medications == null || medications.isEmpty) return false;
        for (var med in medications) {
          if (med['name'] == null || med['name'].toString().isEmpty) {
            return false;
          }
        }
      }
      return true;
    }

    if (compositeType == 'substance_use') {
      final enabledKey = '${question.id}_enabled';
      final frequencyKey = '${question.id}_frequency';
      final enabled = answers[enabledKey] as bool? ?? false;
      if (!enabled) return true;
      final frequency = answers[frequencyKey];
      if (frequency == null || frequency.toString().isEmpty) return false;
      return true;
    }

    if (compositeType == 'somatic_disease') {
      final enabledKey = '${question.id}_enabled';
      final dontKnowKey = '${question.id}_dont_know';
      final subtypesKey = '${question.id}_subtypes';
      final otherTextKey = '${question.id}_other_text';
      final rowKey = question.options?['rowKey'] as String?;

      final enabled = answers[enabledKey] as bool? ?? false;
      final dontKnow = answers[dontKnowKey] as bool? ?? false;

      if (dontKnow) return true;
      if (!enabled) return true;

      if (rowKey == 'other') {
        final otherText = answers[otherTextKey]?.toString().trim() ?? '';
        if (otherText.isEmpty) return false;
        return true;
      }

      final subtypes = answers[subtypesKey] as List<dynamic>? ?? const [];
      if (subtypes.isEmpty) return false;

      if (subtypes.contains('other')) {
        final otherText = answers[otherTextKey]?.toString().trim() ?? '';
        if (otherText.isEmpty) return false;
      }
      return true;
    }

    if (compositeType == 'hours_minutes') {
      final showDontKnow = question.options?['showDontKnow'] == true;
      final dontKnowKey = '${question.id}_dont_know';

      if (showDontKnow && answers[dontKnowKey] == true) {
        return true;
      }

      final hours = answers['${question.id}_hours'];
      final minutes = answers['${question.id}_minutes'];
      return hours != null && minutes != null;
    }

    if (compositeType == 'single_hours' || compositeType == 'single_minutes') {
      return answers[question.id] != null;
    }

    return true;
  }
}
