import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class GAD2SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'GAD_2',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'gad2_symptoms',
          type: QuestionType.table,
          question: 'Jak często odczuwałaś/eś następujące problemy w ostatnich 2 tygodniach?',
          required: true,
          genderForm: 'odczuwałaś',
          options: {
            'rows': [
              {
                'value': 'nervousness',
                'label': '1. Zdenerwowanie, lęk lub irytację',
              },
              {
                'value': 'worrying',
                'label': '2. Trudności związane z opanowaniem zamartwiania się',
              },
            ],
            'columns': [
              {'value': '0', 'label': 'Wcale'},
              {'value': '1', 'label': 'Przez kilka dni'},
              {'value': '2', 'label': 'Więcej niż przez połowę dni'},
              {'value': '3', 'label': 'Prawie każdego dnia'},
            ],
            'rowLabels': {
              'nervousness': '1. Zdenerwowanie, lęk lub irytację',
              'worrying': '2. Trudności związane z opanowaniem zamartwiania się',
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



