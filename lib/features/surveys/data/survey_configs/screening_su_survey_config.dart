import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningSUSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_SU',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'su_substances',
          type: QuestionType.table,
          question: 'Jak często w ciągu ostatnich 30 dni używałeś(aś) poniższych substancji?',
          description: '(Jeśli nie używałeś(aś) – wybierz „0 dni")',
          required: true,
          genderForm: 'używałeś',
          options: {
            'rows': [
              {
                'value': 'alcohol',
                'label': 'Alkohol (piwo, wino, mocniejsze alkohole)',
              },
              {
                'value': 'nicotine',
                'label': 'Nikotyna (papierosy, e-papierosy, podgrzewacze, saszetki)',
              },
              {
                'value': 'caffeine',
                'label': 'Kofeina (kawa, napoje energetyczne, cola)',
              },
              {
                'value': 'cannabinoids',
                'label': 'Kannabinoidy (marihuana, haszysz)',
              },
              {
                'value': 'sedatives',
                'label': 'Leki uspokajające / nasenne (benzodiazepiny, leki nasenne)',
              },
              {
                'value': 'stimulants',
                'label': 'Stymulanty (amfetamina, MDMA, kokaina)',
              },
              {
                'value': 'opioids',
                'label': 'Opioidy (np. kodeina, tramadol)',
              },
              {
                'value': 'hallucinogens',
                'label': 'Substancje halucynogenne (np. LSD, psylocybina, DMT)',
              },
            ],
            'columns': [
              {'value': '0', 'label': '0 dni'},
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2-3 dni'},
              {'value': '4-6', 'label': '4-6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
            'rowLabels': {
              'alcohol': 'Alkohol (piwo, wino, mocniejsze alkohole)',
              'nicotine': 'Nikotyna (papierosy, e-papierosy, podgrzewacze, saszetki)',
              'caffeine': 'Kofeina (kawa, napoje energetyczne, cola)',
              'cannabinoids': 'Kannabinoidy (marihuana, haszysz)',
              'sedatives': 'Leki uspokajające / nasenne (benzodiazepiny, leki nasenne)',
              'stimulants': 'Stymulanty (amfetamina, MDMA, kokaina)',
              'opioids': 'Opioidy (np. kodeina, tramadol)',
              'hallucinogens': 'Substancje halucynogenne (np. LSD, psylocybina, DMT)',
            },
            'columnLabels': {
              '0': '0 dni',
              '1': '1 dzień',
              '2-3': '2-3 dni',
              '4-6': '4-6 dni',
              'daily': 'Codziennie',
            },
          },
        ),
      ],
    );
  }
}



