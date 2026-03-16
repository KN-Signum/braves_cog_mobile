import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningPASurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_PA',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'screening_intro',
          type: QuestionType.text,
          question: 'Czas na miesięczny przegląd',
          description:
              'Co 30 dni prosimy o wypełnienie krótkiego zestawu kwestionariuszy dotyczących Twojego zdrowia i samopoczucia w ostatnim czasie.\n\n'
              'Dzisiejsza sesja obejmuje pytania dotyczące aktywności fizycznej, snu, funkcji poznawczych, nastroju i lęku.\n\n'
              'Szacowany czas: ok. 10–15 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        // Info page
        SurveyQuestionEntity(
          id: 'pa_info',
          type: QuestionType.text,
          question: 'Aktywność fizyczna — ostatnie 30 dni',
          description:
              'Poniższe pytania dotyczą czasu poświęconego na aktywność fizyczną różnego rodzaju w ciągu ostatniego miesiąca.\n\n'
              'Wybierz opcję najbliższą rzeczywistości — jeśli dana aktywność nie dotyczy Ciebie, wybierz "0 minut".\n\n'
              'Szacowany czas: ok. 1–2 minuty.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'pa_light',
          type: QuestionType.choice,
          question:
              'Lekka aktywność fizyczna',
          description: 'np. spokojny spacer, prace domowe, rozciąganie',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': '0 min'},
              {'value': '30', 'label': '30 min'},
              {'value': '60', 'label': '60 min'},
              {'value': '120', 'label': '120 min'},
              {'value': '180+', 'label': '≥180 min'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'pa_moderate',
          type: QuestionType.choice,
          question:
              'Umiarkowana aktywność fizyczna',
          description:
              'np. szybki marsz, rower w spokojnym tempie, taniec, prace ogrodowe',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': '0 min'},
              {'value': '30', 'label': '30 min'},
              {'value': '60', 'label': '60 min'},
              {'value': '120', 'label': '120 min'},
              {'value': '180+', 'label': '≥180 min'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'pa_vigorous',
          type: QuestionType.choice,
          question:
              'Wysoka aktywność fizyczna',
          description:
              'np. bieganie, intensywny rower, pływanie, trening siłowy, sport zespołowy',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': '0 min'},
              {'value': '30', 'label': '30 min'},
              {'value': '60', 'label': '60 min'},
              {'value': '120', 'label': '120 min'},
              {'value': '180+', 'label': '≥180 min'},
            ],
          },
        ),
      ],
    );
  }
}

