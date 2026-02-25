import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class MedicationsSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Medications',
      title: 'Leki',
      questions: [
        SurveyQuestionEntity(
          id: 'medications',
          type: QuestionType.boolean,
          question:
              'Czy przyjmujesz obecnie jakiekolwiek leki (na choroby somatyczne lub psychiczne)?',
          required: true,
          options: {
            'composite': 'medications',
          },
        ),
      ],
    );
  }
}


