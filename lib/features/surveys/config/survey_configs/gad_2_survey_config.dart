import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class GAD2SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'GAD_2',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'gad2_info',
          type: QuestionType.text,
          question: 'Lęk — ostatnie 2 tygodnie',
          description:
              'W tej części prosimy o informacje dotyczące Twojej aktywności fizycznej w ciągu ostatnich 7 dni — w pracy, w domu i w czasie wolnym.\n\n'
              'Pytania dotyczą intensywnych i umiarkowanych ćwiczeń, a także codziennego chodzenia i czasu spędzanego w pozycji siedzącej.\n\n'
              'Szacowany czas: ok. 3–5 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'gad2_1',
          type: QuestionType.choice,
          question:
              'Jak często w ciągu ostatnich 2 tygodni odczuwałeś zdenerwowanie, lęk lub irytację?',
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
          id: 'gad2_2',
          type: QuestionType.choice,
          question:
              'Jak często w ciągu ostatnich 2 tygodni miałeś trudności z opanowaniem zamartwiania się?',
          required: true,
          genderForm: 'miałeś',
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



