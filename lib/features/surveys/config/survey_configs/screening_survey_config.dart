import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningSurveyConfig {
  static SurveyEntity getSurvey() {
    // This will be expanded later with other screening sections
    // For now, it's a placeholder
    return SurveyEntity(
      id: 'screening',
      title: 'Screening',
      questions: [
        // Placeholder - will be expanded with sleep quality, cognitive complaints, etc.
        SurveyQuestionEntity(
          id: 'placeholder',
          type: QuestionType.text,
          question: 'To będzie rozbudowane później',
          required: false,
        ),
      ],
    );
  }
}



