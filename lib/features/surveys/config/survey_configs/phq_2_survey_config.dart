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
          question: 'Następne pytania dotyczą Twojego samopoczucia psychicznego oraz objawów, których mogłeś/-aś doświadczać w ostatnim czasie. Przeczytaj uważnie każde stwierdzenie i zaznacz, jak często występował u Ciebie dany objaw w ciągu ostatnich 2 tygodni. Odpowiadaj zgodnie z własnym doświadczeniem — nie ma odpowiedzi dobrych ani złych.',
          required: false,
          options: {
            'info': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'phq2_1',
          type: QuestionType.choice,
          question:
              'Jak często w ciągu ostatnich 2 tygodni odczuwałaś/eś małe zainteresowanie albo brak przyjemności w robieniu czegokolwiek?',
          required: true,
          genderForm: 'odczuwałaś',
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
              'Jak często w ciągu ostatnich 2 tygodni odczuwałaś/eś smutek, przygnębienie lub beznadziejność?',
          required: true,
          genderForm: 'odczuwałaś',
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



