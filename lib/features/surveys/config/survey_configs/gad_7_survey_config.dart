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
          question: 'Lęk i stres',
          description:
              'W tej sekcji znajdziesz pytania dotyczące Twojego poziomu lęku i odczuwanego stresu.\n\n'
              'Pierwsza część dotyczy ostatnich dwóch tygodni, druga — ostatniego miesiąca. Odpowiadaj zgodnie z tym, jak się rzeczywiście czułeś — nie ma odpowiedzi błędnych.\n\n'
              'Po wypełnieniu tej sekcji zobaczysz krótki komunikat z informacją o Twoim wyniku.\n\n'
              'Szacowany czas: ok. 5–7 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
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









