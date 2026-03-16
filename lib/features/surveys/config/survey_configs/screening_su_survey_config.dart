import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningSUSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'screening_SU',
      title: 'Screening',
      questions: [
        // Info page
        SurveyQuestionEntity(
          id: 'su_info',
          type: QuestionType.text,
          question: 'Używanie substancji',
          description:
              'Poniższe pytania dotyczą spożywania alkoholu, nikotyny, kofeiny i innych substancji psychoaktywnych w ciągu ostatnich 30 dni.\n\n'
              'Dane są anonimowe i służą wyłącznie celom badawczym. Prosimy o szczere odpowiedzi — nie ma tu dobrych ani złych wyborów.\n\n'
              'Szacowany czas: ok. 3–5 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
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
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceDescription': '(papierosy, e-papierosy, podgrzewacze tytoniu, saszetki nikotynowe)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceDescription': '(kawa, napoje energetyczne, cola, suplementy kofeinowe)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Syntetyczne Kannabinoidy
        SurveyQuestionEntity(
          id: 'su_synthetic_cannabinoids',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'syntheticcannabinoids',
            'substanceLabel': 'Syntetyczne kannabinoidy',
            'substanceDescription': '(np. Spice, K2)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceDescription': '(np. amfetamina, metamfetamina, kokaina, MDMA/ecstasy)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Stymulanty bez zaleceń medycznych
        SurveyQuestionEntity(
          id: 'su_stimulants',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'stimulants_without_medical_recommendation',
            'substanceLabel': 'Leki stymulujące stosowane bez wskazań medycznych ',
            'substanceDescription': '(np. metylofenidat, lisdeksamfetamina, amfetamina, “Adderal”, modafinil)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceDescription': '(np. kodeina, tramadol, morfina, oksykodon, heroina, fentanyl)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Ketamina
        SurveyQuestionEntity(
          id: 'su_ketamine',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'ketamine',
            'substanceLabel': 'Ketamina i inne dysocjanty',
            'substanceDescription': '(ketamina, PCP)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceLabel': 'Halocynogeny klasyczne',
            'substanceDescription': '(LSD, psylocybina, DMT, meskalina)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Nowe substancje psychoaktywne
        SurveyQuestionEntity(
          id: 'su_new_psychoactive_substances',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'new_psychoactive_substances',
            'substanceLabel': 'Nowe substancje psychoaktywne (NPS)',
            'substanceDescription': '(np. mefedron, syntetyczne katynony)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // GHB/GBL
        SurveyQuestionEntity(
          id: 'su_ghb_gbl',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'ghb_gbl',
            'substanceLabel': 'GHB/GBL',
            //'substanceDescription': '',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
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
            'substanceDescription': '(benzodiazepiny, zolpidem, zopiklon)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Inhalanty
        SurveyQuestionEntity(
          id: 'su_inhalants',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'inhalants',
            'substanceLabel': 'Inhalanty',
            'substanceDescription': '(rozpuszczalniki, kleje, gaz zapalniczkowy, podtlenek azotu)',
            'frequencies': [
              {'value': '1-2', 'label': '1–2 dni'},
              {'value': '3-5', 'label': '3–5 dni'},
              {'value': '6-9', 'label': '6–9 dni'},
              {'value': '10-19', 'label': '10–19 dni'},
              {'value': '20-29', 'label': '20–29 dni'},
              {'value': 'daily', 'label': 'Codziennie'},
            ],
          },
        ),
        // Inne 
        SurveyQuestionEntity(
          id: 'su_other',
          type: QuestionType.boolean,
          question: 'Czy w ciągu ostatnich 30 dni używałeś poniższych używek?',
          required: true,
          options: {
            'composite': 'substance_use',
            'rowKey': 'other',
            'substanceLabel': 'Inne substancje',
            'askName': true,
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



