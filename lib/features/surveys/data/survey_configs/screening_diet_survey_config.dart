import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningDietSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_diet',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'diet_changed',
          type: QuestionType.boolean,
          question: 'Czy w ostatnim miesiącu zmieniły się Twoje nawyki żywieniowe?',
          required: true,
          options: {
            'trueLabel': 'Tak',
            'falseLabel': 'Nie',
          },
        ),
      ],
    );
  }
}



