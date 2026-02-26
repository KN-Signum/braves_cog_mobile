import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PsychiatricMedicationsSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Mental_Health_Medications',
      title: 'Leki psychiatryczne',
      questions: [
        SurveyQuestionEntity(
          id: 'psychiatric_medications',
          type: QuestionType.boolean,
          question: 'Czy przyjmujesz leki psychiatryczne?',
          required: true,
          options: {
            'composite': 'medications',
            'medicationType': 'psychiatric',
          },
        ),
      ],
    );
  }
}























