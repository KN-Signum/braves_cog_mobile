import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PHQ2SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'PHQ_2',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'phq2_symptoms',
          type: QuestionType.table,
          question: 'Jak często odczuwałaś/eś następujące problemy w ostatnich 2 tygodniach?',
          required: true,
          genderForm: 'odczuwałaś',
          options: {
            'rows': [
              {
                'value': 'interest',
                'label': '1. Małe zainteresowanie albo brak przyjemności w robieniu czegokolwiek',
              },
              {
                'value': 'sadness',
                'label': '2. Odczuwanie smutku, przygnębienia lub beznadziejności',
              },
            ],
            'columns': [
              {'value': '0', 'label': 'Wcale'},
              {'value': '1', 'label': 'Przez kilka dni'},
              {'value': '2', 'label': 'Więcej niż przez połowę dni'},
              {'value': '3', 'label': 'Prawie każdego dnia'},
            ],
            'rowLabels': {
              'interest': '1. Małe zainteresowanie albo brak przyjemności w robieniu czegokolwiek',
              'sadness': '2. Odczuwanie smutku, przygnębienia lub beznadziejności',
            },
            'columnLabels': {
              '0': 'Wcale',
              '1': 'Przez kilka dni',
              '2': 'Więcej niż przez połowę dni',
              '3': 'Prawie każdego dnia',
            },
          },
        ),
      ],
    );
  }
}



