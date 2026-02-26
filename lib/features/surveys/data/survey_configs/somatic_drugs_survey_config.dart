import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class SomaticDrugsSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Somatic_Drugs',
      title: 'Leki somatyczne',
      questions: [
        SurveyQuestionEntity(
          id: 'somatic_medications',
          type: QuestionType.boolean,
          question: 'Czy przyjmujesz leki na choroby somatyczne?',
          required: true,
          options: {
            'composite': 'medications',
            'medicationType': 'somatic',
          },
        ),
      ],
    );
  }
}























