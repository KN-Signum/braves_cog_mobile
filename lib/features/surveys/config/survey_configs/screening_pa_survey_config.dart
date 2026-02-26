import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningPASurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_PA',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'pa_light',
          type: QuestionType.choice,
          question:
              'Ile łącznie minut w ciągu ostatnich 30 dni poświęciłeś(aś) na lekką aktywność fizyczną?',
          description: '(np. spokojny spacer, prace domowe, rozciąganie)',
          required: true,
          genderForm: 'poświęciłeś',
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
              'Ile łącznie minut w ciągu ostatnich 30 dni poświęciłeś(aś) na umiarkowaną aktywność fizyczną?',
          description:
              '(np. szybki marsz, rower w spokojnym tempie, taniec, prace ogrodowe)',
          required: true,
          genderForm: 'poświęciłeś',
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
              'Ile łącznie minut w ciągu ostatnich 30 dni poświęciłeś(aś) na wysoką aktywność fizyczną?',
          description:
              '(np. bieganie, intensywny rower, pływanie, trening siłowy, sport zespołowy)',
          required: true,
          genderForm: 'poświęciłeś',
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

