import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class PSS10SurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Stress_And_Anxiety_PSS10',
      title: 'Stres (PSS-10)',
      questions: [
        SurveyQuestionEntity(
          id: 'pss10_info',
          type: QuestionType.text,
          question: 'Pytania zawarte w tej skali dotyczą Twoich myśli i odczuć związanych z doświadczanymi w ostatnim miesiącu zdarzeniami.\nW każdym pytaniu należy wskazać, jak często myślałeś/aś i odczuwałeś/aś w podany sposób.\nMimo znacznych podobieństw są to różne pytania i każde z nich należy traktować oddzielnie.\nNajlepiej na każde pytanie odpowiadać w miarę szybko, wybierając tę odpowiedź, która wydaje się najbardziej trafna.\n\nPrzy każdym pytaniu należy wpisać do kratki z prawej strony odpowiednią cyfrę, zgodnie z podanym poniżej znaczeniem:\n0 – nigdy\n1 – prawie nigdy\n2 – czasem\n3 – dość często\n4 – bardzo często',
          required: false,
          options: {
            'info': true,
          },
        ),
        // 1
        SurveyQuestionEntity(
          id: 'pss10_1',
          type: QuestionType.choice,
          question: 'Jak często w ciągu ostatniego miesiąca byłeś/aś zdenerwowany/a, ponieważ zdarzyło się coś niespodziewanego?',
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
          question: 'Jak często w ciągu ostatniego miesiąca czułeś/aś, że ważne sprawy w Twoim życiu wymykają się spod kontroli?',
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
          question: 'Jak często w ciągu ostatniego miesiąca odczuwałeś/aś zdenerwowanie i napięcie?',
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
          question: 'Jak często w ciągu ostatniego miesiąca byłeś/aś przekonany/a, że jesteś w stanie poradzić sobie z problemami osobistymi?',
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
          question: 'Jak często w ciągu ostatniego miesiąca czułeś/aś, że sprawy układają się po Twojej myśli?',
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
          question: 'Jak często w ciągu ostatniego miesiąca stwierdzałeś/aś, że nie radzisz sobie ze wszystkimi obowiązkami?',
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
          question: 'Jak często w ciągu ostatniego miesiąca potrafiłeś/aś opanować swoje rozdrażnienie?',
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
          question: 'Jak często w ciągu ostatniego miesiąca czułeś/aś, że wszystko Ci wychodzi?',
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
          question: 'Jak często w ciągu ostatniego miesiąca złościłeś/aś się, ponieważ nie miałeś/aś wpływu na to, co się zdarzyło?',
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
          question: 'Jak często w ciągu ostatniego miesiąca czułeś/aś, że nie możesz przezwyciężyć narastających trudności?',
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









