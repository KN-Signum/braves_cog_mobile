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
          question: 'Następne stwierdzenia dotyczą Twoich doświadczeń związanych z odczuwaniem lęku, napięcia oraz zamartwiania się w codziennym życiu. Przeczytaj uważnie każde stwierdzenie i zaznacz, w jakim stopniu odnosi się ono do Ciebie w ostatnim czasie. Odpowiadaj zgodnie z tym, jak rzeczywiście się czujesz — nie ma odpowiedzi dobrych ani złych.',
          required: false,
          options: {
            'info': true,
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



