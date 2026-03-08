import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PHQ9SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Depression',
      title: 'Depresja (PHQ-9)',
      questions: [
        SurveyQuestionEntity(
          id: 'phq9_info',
          type: QuestionType.text,
          question: 'Następne pytania dotyczą Twojego samopoczucia psychicznego oraz objawów, których mogłeś doświadczać w ostatnim czasie. Przeczytaj uważnie każde stwierdzenie i zaznacz, jak często występował u Ciebie dany objaw w ciągu ostatnich 2 tygodni. Odpowiadaj zgodnie z własnym doświadczeniem — nie ma odpowiedzi dobrych ani złych.',
          required: false,
          options: {
            'info': true,
          },
        ),
        // 1
        SurveyQuestionEntity(
          id: 'phq9_1',
          type: QuestionType.choice,
          question: 'Niewielkie zainteresowanie lub odczuwanie przyjemności z wykonywania czynności',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 2
        SurveyQuestionEntity(
          id: 'phq9_2',
          type: QuestionType.choice,
          question: 'Uczucie smutku, przygnębienia lub beznadziejności',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 3
        SurveyQuestionEntity(
          id: 'phq9_3',
          type: QuestionType.choice,
          question: 'Kłopoty z zaśnięciem lub przerywany sen, albo zbyt długi sen',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 4
        SurveyQuestionEntity(
          id: 'phq9_4',
          type: QuestionType.choice,
          question: 'Uczucie zmęczenia lub brak energii',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 5
        SurveyQuestionEntity(
          id: 'phq9_5',
          type: QuestionType.choice,
          question: 'Brak apetytu lub przejadanie się',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 6
        SurveyQuestionEntity(
          id: 'phq9_6',
          type: QuestionType.choice,
          question: 'Poczucie niezadowolenia z siebie — lub uczucie, że jest się do niczego, albo że zawiodłeś siebie lub rodzinę',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 7
        SurveyQuestionEntity(
          id: 'phq9_7',
          type: QuestionType.choice,
          question: 'Problemy ze skupieniem się, na przykład przy czytaniu gazety lub oglądaniu telewizji',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 8
        SurveyQuestionEntity(
          id: 'phq9_8',
          type: QuestionType.choice,
          question: 'Poruszanie się lub mówienie tak wolno, że inni mogli to zauważyć, albo wręcz przeciwnie — niemożność usiedzenia w miejscu lub podenerwowanie powodujące ruchliwość znacznie większą niż zwykle',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        // 9
        SurveyQuestionEntity(
          id: 'phq9_9',
          type: QuestionType.choice,
          question: 'Myśli, że lepiej byłoby umrzeć, albo chęć zrobienia sobie jakiejś krzywdy',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Wcale nie dokuczały'},
              {'value': 1, 'label': 'Kilka dni'},
              {'value': 2, 'label': 'Więcej niż połowę dni'},
              {'value': 3, 'label': 'Niemal codziennie'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'phq9_difficulty',
          type: QuestionType.choice,
          question: 'Jeżeli zaznaczyłeś którekolwiek z problemów, jak bardzo utrudniły one wykonywanie pracy, zajmowanie się domem lub relacje z innymi ludźmi?',
          required: true,
          options: {
            'options': [
              {'value': 'not_at_all', 'label': 'W ogóle nie utrudniły'},
              {'value': 'somewhat', 'label': 'Trochę utrudniły'},
              {'value': 'very', 'label': 'Bardzo utrudniły'},
              {'value': 'extremely', 'label': 'Niezmiernie utrudniły'},
            ],
            'conditionalLogic': {
              'showIf': {
                'questionId': 'phq9_any_positive',
                'operator': '==',
                'value': true,
              },
            },
          },
        ),
      ],
    );
  }
}









