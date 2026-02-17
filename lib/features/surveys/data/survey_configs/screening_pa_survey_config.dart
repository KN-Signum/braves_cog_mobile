import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningPASurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_PA',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'pa_activity',
          type: QuestionType.table,
          question: 'Ile łącznie minut w ciągu ostatnich 30 dni poświęciłeś(aś) na poniższe typy aktywności?',
          description: '(Jeśli nie wykonywałeś(aś) danej aktywności – wybierz 0)',
          required: true,
          genderForm: 'poświęciłeś',
          options: {
            'rows': [
              {
                'value': 'lekka',
                'label': 'Lekka',
              },
              {
                'value': 'umiarkowana',
                'label': 'Umiarkowana',
              },
              {
                'value': 'wysoka',
                'label': 'Wysoka',
              },
            ],
            'columns': [
              {'value': '0', 'label': '0 min'},
              {'value': '30', 'label': '30 min'},
              {'value': '60', 'label': '60 min'},
              {'value': '120', 'label': '120 min'},
              {'value': '180+', 'label': '≥180 min'},
            ],
            'rowLabels': {
              'lekka': 'Lekka',
              'umiarkowana': 'Umiarkowana',
              'wysoka': 'Wysoka',
            },
            'rowTooltips': {
              'lekka': 'np. spokojny spacer, prace domowe, rozciąganie',
              'umiarkowana': 'np. szybki marsz, rower w spokojnym tempie, taniec, prace ogrodowe',
              'wysoka': 'np. bieganie, intensywny rower, pływanie, trening siłowy, sport zespołowy',
            },
          },
        ),
      ],
    );
  }
}

