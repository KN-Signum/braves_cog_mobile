import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class MentalDisordersSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Mental_Health_Disorders',
      title: 'Zaburzenia psychiczne',
      questions: [
        // Główne pytanie (info) – tekst u góry, jak przy chorobach somatycznych.
        SurveyQuestionEntity(
          id: 'mental_info',
          type: QuestionType.choice,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: false,
          options: {
            'info': true,
          },
        ),

        // Depresja
        SurveyQuestionEntity(
          id: 'mental_depression',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'depression',
            'diseaseLabel': 'Depresja',
            'diseaseDescription':
                '(epizod depresyjny, depresja nawracająca, dystymia, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'episode', 'label': 'Epizod depresyjny'},
              {'value': 'recurrent', 'label': 'Depresja nawracająca'},
              {'value': 'dysthymia', 'label': 'Dystymia'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia lękowe
        SurveyQuestionEntity(
          id: 'mental_anxiety',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'anxiety',
            'diseaseLabel': 'Zaburzenia lękowe',
            'diseaseDescription':
                '(lęk uogólniony, napady paniki, fobie, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'gad', 'label': 'Lęk uogólniony'},
              {'value': 'panic', 'label': 'Napady paniki'},
              {'value': 'phobias', 'label': 'Fobie'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // ADHD
        SurveyQuestionEntity(
          id: 'mental_adhd',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'adhd',
            'diseaseLabel': 'ADHD',
            'diseaseDescription':
                '(typ z przewagą nieuwagi, typ z przewagą nadpobudliwości-impulsywności, typ mieszany, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {
                'value': 'inattentive',
                'label': 'Typ z przewagą nieuwagi',
              },
              {
                'value': 'hyperactive_impulsive',
                'label': 'Typ z przewagą nadpobudliwości-impulsywności',
              },
              {'value': 'combined', 'label': 'Typ mieszany'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia ze spektrum autyzmu (ASD)
        SurveyQuestionEntity(
          id: 'mental_asd',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'asd',
            'diseaseLabel': 'Zaburzenia ze spektrum autyzmu (ASD)',
            'diseaseDescription':
                '(autyzm dziecięcy, zespół Aspergera, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'childhood_autism', 'label': 'Autyzm dziecięcy'},
              {'value': 'asperger', 'label': 'Zespół Aspergera'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Choroba afektywna dwubiegunowa
        SurveyQuestionEntity(
          id: 'mental_bipolar',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'bipolar',
            'diseaseLabel': 'Choroba afektywna dwubiegunowa',
            'diseaseDescription': '(typ I, typ II, cyklotymia, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'type1', 'label': 'Typ I'},
              {'value': 'type2', 'label': 'Typ II'},
              {'value': 'cyclothymia', 'label': 'Cyklotymia'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia psychotyczne
        SurveyQuestionEntity(
          id: 'mental_psychotic',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'psychotic',
            'diseaseLabel': 'Zaburzenia psychotyczne',
            'diseaseDescription':
                '(schizofrenia, zaburzenie schizoafektywne, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'schizophrenia', 'label': 'Schizofrenia'},
              {
                'value': 'schizoaffective',
                'label': 'Zaburzenie schizoafektywne',
              },
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia obsesyjno-kompulsyjne (OCD)
        SurveyQuestionEntity(
          id: 'mental_ocd',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'ocd',
            'diseaseLabel': 'Zaburzenia obsesyjno-kompulsyjne (OCD)',
            'diseaseDescription': '(OCD, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'ocd', 'label': 'OCD'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zespół stresu pourazowego (PTSD)
        SurveyQuestionEntity(
          id: 'mental_ptsd',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'ptsd',
            'diseaseLabel': 'Zespół stresu pourazowego (PTSD)',
            'diseaseDescription': '(PTSD, złożone PTSD, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'ptsd', 'label': 'PTSD'},
              {'value': 'cptsd', 'label': 'Złożone PTSD'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia odżywiania
        SurveyQuestionEntity(
          id: 'mental_eating',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'eating',
            'diseaseLabel': 'Zaburzenia odżywiania',
            'diseaseDescription': '(anoreksja, bulimia, BED, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'anorexia', 'label': 'Anoreksja'},
              {'value': 'bulimia', 'label': 'Bulimia'},
              {'value': 'bed', 'label': 'BED'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia snu
        SurveyQuestionEntity(
          id: 'mental_sleep',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'sleep',
            'diseaseLabel': 'Zaburzenia snu',
            'diseaseDescription': '(bezsenność, hipersomnia, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'insomnia', 'label': 'Bezsenność'},
              {'value': 'hypersomnia', 'label': 'Hipersomnia'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Uzależnienie / zaburzenia używania substancji
        SurveyQuestionEntity(
          id: 'mental_substance',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'substance',
            'diseaseLabel': 'Uzależnienie / zaburzenia używania substancji',
            'diseaseDescription': '(alkohol, nikotyna, opioidy, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'alcohol', 'label': 'Alkohol'},
              {'value': 'nicotine', 'label': 'Nikotyna'},
              {'value': 'opioids', 'label': 'Opioidy'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Zaburzenia osobowości
        SurveyQuestionEntity(
          id: 'mental_personality',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'personality',
            'diseaseLabel': 'Zaburzenia osobowości',
            'diseaseDescription':
                '(borderline, narcystyczne, unikające, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'borderline', 'label': 'Borderline'},
              {'value': 'narcissistic', 'label': 'Narcystyczne'},
              {'value': 'avoidant', 'label': 'Unikające'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),

        // Inne zaburzenie psychiczne – tylko wolny tekst (jak przy "Inne choroby somatyczne").
        SurveyQuestionEntity(
          id: 'mental_other',
          type: QuestionType.boolean,
          question:
              'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'other',
            'diseaseLabel': 'Inne zaburzenie psychiczne',
            'diseaseDescription': null,
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
      ],
    );
  }
}

