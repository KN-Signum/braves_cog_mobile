import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PHQ2SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'PHQ_2',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'phq2_info',
          type: QuestionType.text,
          question: 'Nastrój — ostatnie 2 tygodnie',
          description:
              'Dwa krótkie pytania dotyczące Twojego nastroju i odczuwania przyjemności w ostatnich dwóch tygodniach.\n\n'
              'Szacowany czas: ok. 1 minuty.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'phq2_1',
          type: QuestionType.choice,
          question:
              'Jak często w ciągu ostatnich 2 tygodni odczuwałeś małe zainteresowanie albo brak przyjemności w robieniu czegokolwiek?',
          required: true,
          genderForm: 'odczuwałeś',
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Przez kilka dni'},
              {'value': 2, 'label': 'Więcej niż przez połowę dni'},
              {'value': 3, 'label': 'Prawie każdego dnia'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'phq2_2',
          type: QuestionType.choice,
          question:
              'Jak często w ciągu ostatnich 2 tygodni odczuwałeś smutek, przygnębienie lub beznadziejność?',
          required: true,
          genderForm: 'odczuwałeś',
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale'},
              {'value': 1, 'label': 'Przez kilka dni'},
              {'value': 2, 'label': 'Więcej niż przez połowę dni'},
              {'value': 3, 'label': 'Prawie każdego dnia'},
            ],
          },
        ),
      ],
    );
  }
}



