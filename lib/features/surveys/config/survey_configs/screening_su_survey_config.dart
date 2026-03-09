import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningSUSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_SU',
      title: 'Screening',
      questions: [
        // Alkohol
        SurveyQuestionEntity(
          id: 'su_alcohol',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'alcohol',
            'substanceLabel': 'Alkohol',
            'substanceDescription': '(piwo, wino, mocniejsze alkohole)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Nikotyna
        SurveyQuestionEntity(
          id: 'su_nicotine',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'nicotine',
            'substanceLabel': 'Nikotyna',
            'substanceDescription': '(papierosy, e-papierosy, podgrzewacze, saszetki)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Kofeina
        SurveyQuestionEntity(
          id: 'su_caffeine',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'caffeine',
            'substanceLabel': 'Kofeina',
            'substanceDescription': '(kawa, napoje energetyczne, cola)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Kannabinoidy
        SurveyQuestionEntity(
          id: 'su_cannabinoids',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'cannabinoids',
            'substanceLabel': 'Kannabinoidy',
            'substanceDescription': '(marihuana, haszysz)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Leki uspokajające / nasenne
        SurveyQuestionEntity(
          id: 'su_sedatives',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'sedatives',
            'substanceLabel': 'Leki uspokajające / nasenne',
            'substanceDescription': '(benzodiazepiny, leki nasenne)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Stymulanty
        SurveyQuestionEntity(
          id: 'su_stimulants',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'stimulants',
            'substanceLabel': 'Stymulanty',
            'substanceDescription': '(amfetamina, MDMA, kokaina)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Opioidy
        SurveyQuestionEntity(
          id: 'su_opioids',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'opioids',
            'substanceLabel': 'Opioidy',
            'substanceDescription': '(np. kodeina, tramadol)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Substancje halucynogenne
        SurveyQuestionEntity(
          id: 'su_hallucinogens',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'hallucinogens',
            'substanceLabel': 'Substancje halucynogenne',
            'substanceDescription': '(np. LSD, psylocybina, DMT)',
            'frequencies': [
              {'value': '1', 'label': '1 dzień'},
              {'value': '2-3', 'label': '2–3 dni'},
              {'value': '4-6', 'label': '4–6 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
      ],
    );
  }
}



