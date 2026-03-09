import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class GAD7SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Stress_And_Anxiety_GAD7',
      title: 'Lęk (GAD-7)',
      questions: [
        SurveyQuestionEntity(
          id: 'gad7_info',
          type: QuestionType.text,
          question: 'Następne stwierdzenia dotyczą Twoich doświadczeń związanych z odczuwaniem lęku, napięcia oraz zamartwiania się w codziennym życiu. Przeczytaj uważnie każde stwierdzenie i zaznacz, w jakim stopniu odnosi się ono do Ciebie w ostatnim czasie. Odpowiadaj zgodnie z tym, jak rzeczywiście się czujesz — nie ma odpowiedzi dobrych ani złych.',
          required: false,
          options: {
            'info': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'gad7_info',
          type: QuestionType.text,
          question: 'Jak często w ciągu ostatnich 2 tygodni dokuczały ci następujące problemy?',
          required: false,
          options: {
            'info': true,
          },
        ),
        // 1
        SurveyQuestionEntity(
          id: 'gad7_1',
          type: QuestionType.choice,
          question: 'Czułeś się podenerwowany, niespokojny, mocno spięty',
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
          id: 'gad7_2',
          type: QuestionType.choice,
          question: 'Nie mogłeś przestać się martwić albo zapanować nad tym',
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
          id: 'gad7_3',
          type: QuestionType.choice,
          question: 'Za bardzo się martwiłeś różnymi rzeczami',
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
          id: 'gad7_4',
          type: QuestionType.choice,
          question: 'Miałeś trudności z relaksowaniem się',
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
          id: 'gad7_5',
          type: QuestionType.choice,
          question: 'Byłeś tak niespokojny, że nie mogłeś usiedzieć na miejscu',
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
          id: 'gad7_6',
          type: QuestionType.choice,
          question: 'Łatwo stawałeś się rozdrażniony lub poirytowany',
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
          id: 'gad7_7',
          type: QuestionType.choice,
          question: 'Obawiałeś się, tak jakby miało się stać coś strasznego',
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
      ],
    );
  }
}









