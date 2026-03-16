import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PSS10SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Stress_And_Anxiety_PSS10',
      title: 'Stres (PSS-10)',
      questions: [

        // 1
        SurveyQuestionEntity(
          id: 'pss10_1',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca byłeś zdenerwowany, ponieważ zdarzyło się coś niespodziewanego?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 2
        SurveyQuestionEntity(
          id: 'pss10_2',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca czułeś, że ważne sprawy w Twoim życiu wymykają się spod kontroli?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 3
        SurveyQuestionEntity(
          id: 'pss10_3',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca odczuwałeś zdenerwowanie i napięcie?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 4
        SurveyQuestionEntity(
          id: 'pss10_4',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca byłeś przekonany, że jesteś w stanie poradzić sobie z problemami osobistymi?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 5
        SurveyQuestionEntity(
          id: 'pss10_5',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca czułeś, że sprawy układają się po Twojej myśli?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 6
        SurveyQuestionEntity(
          id: 'pss10_6',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca stwierdzałeś, że nie radzisz sobie ze wszystkimi obowiązkami?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 7
        SurveyQuestionEntity(
          id: 'pss10_7',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca potrafiłeś opanować swoje rozdrażnienie?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 8
        SurveyQuestionEntity(
          id: 'pss10_8',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca czułeś, że wszystko Ci wychodzi?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 9
        SurveyQuestionEntity(
          id: 'pss10_9',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca złościłeś się, ponieważ nie miałeś wpływu na to, co się zdarzyło?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
        // 10
        SurveyQuestionEntity(
          id: 'pss10_10',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca czułeś, że nie możesz przezwyciężyć narastających trudności?',
          required: true,
          options: {
            'options': [
              {'value': 0, 'label': 'Nigdy'},
              {'value': 1, 'label': 'Prawie nigdy'},
              {'value': 2, 'label': 'Czasem'},
              {'value': 3, 'label': 'Dość często'},
              {'value': 4, 'label': 'Bardzo często'},
            ],
          },
        ),
      ],
    );
  }
}









