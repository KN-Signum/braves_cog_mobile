import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class SomaticDiseasesSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Somatic_Disease',
      title: 'Choroby somatyczne',
      questions: [
        SurveyQuestionEntity(
          id: 'somatic_info',
          type: QuestionType.choice,
          question: 'Historia zdrowia',
          description:
              'W tej sekcji prosimy o informacje dotyczące Twoich wcześniejszych lub obecnych rozpoznań lekarskich — zarówno w zakresie zdrowia psychicznego, jak i somatycznego.\n\n'
              'Zaznacz tylko te schorzenia, które zostały u Ciebie oficjalnie rozpoznane przez lekarza lub psychologa. Jeśli nie jesteś pewien — wybierz opcję "Nie wiem".\n\n'
              'Szacowany czas: ok. 3–5 minut.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        // Choroby układu krążenia
        SurveyQuestionEntity(
          id: 'somatic_cardiovascular',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'cardiovascular',
            'diseaseLabel': 'Choroby układu krążenia',
            'diseaseDescription': '(nadciśnienie, choroba wieńcowa, arytmie, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'hypertension', 'label': 'Nadciśnienie'},
              {'value': 'coronary', 'label': 'Choroba wieńcowa'},
              {'value': 'arrhythmia', 'label': 'Arytmie'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Cukrzyca
        SurveyQuestionEntity(
          id: 'somatic_diabetes',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'diabetes',
            'diseaseLabel': 'Cukrzyca',
            'diseaseDescription': '(typ 1, typ 2, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'type1', 'label': 'Cukrzyca typu 1'},
              {'value': 'type2', 'label': 'Cukrzyca typu 2'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Inne choroby metaboliczne
        SurveyQuestionEntity(
          id: 'somatic_metabolic',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'metabolic',
            'diseaseLabel': 'Inne choroby metaboliczne',
            'diseaseDescription': '(otyłość, dyslipidemia, insulinooporność, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'obesity', 'label': 'Otyłość'},
              {'value': 'dyslipidemia', 'label': 'Dyslipidemia'},
              {'value': 'insulin_resistance', 'label': 'Insulinooporność'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby tarczycy
        SurveyQuestionEntity(
          id: 'somatic_thyroid',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'thyroid',
            'diseaseLabel': 'Choroby tarczycy',
            'diseaseDescription': '(niedoczynność, nadczynność, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'hypothyroidism', 'label': 'Niedoczynność'},
              {'value': 'hyperthyroidism', 'label': 'Nadczynność'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby neurologiczne
        SurveyQuestionEntity(
          id: 'somatic_neurological',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'neurological',
            'diseaseLabel': 'Choroby neurologiczne',
            'diseaseDescription': '(padaczka, SM, udar, migrena, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'epilepsy', 'label': 'Padaczka'},
              {'value': 'ms', 'label': 'Stwardnienie rozsiane (SM)'},
              {'value': 'stroke', 'label': 'Udar'},
              {'value': 'migraine', 'label': 'Migrena'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby autoimmunologiczne
        SurveyQuestionEntity(
          id: 'somatic_autoimmune',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'autoimmune',
            'diseaseLabel': 'Choroby autoimmunologiczne',
            'diseaseDescription': '(RZS, toczeń, Hashimoto, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'ra', 'label': 'Reumatoidalne zapalenie stawów (RZS)'},
              {'value': 'sle', 'label': 'Toczeń'},
              {'value': 'hashimoto', 'label': 'Hashimoto'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby układu oddechowego
        SurveyQuestionEntity(
          id: 'somatic_respiratory',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'respiratory',
            'diseaseLabel': 'Choroby układu oddechowego',
            'diseaseDescription': '(astma, POChP, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'asthma', 'label': 'Astma'},
              {'value': 'copd', 'label': 'POChP'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby przewodu pokarmowego
        SurveyQuestionEntity(
          id: 'somatic_gastrointestinal',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'gastrointestinal',
            'diseaseLabel': 'Choroby przewodu pokarmowego',
            'diseaseDescription': '(IBS, IBD, choroba wrzodowa, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'ibs', 'label': 'Zespół jelita drażliwego (IBS)'},
              {'value': 'ibd', 'label': 'Nieswoiste zapalenia jelit (IBD)'},
              {'value': 'ulcer', 'label': 'Choroba wrzodowa'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby wątroby
        SurveyQuestionEntity(
          id: 'somatic_liver',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'liver',
            'diseaseLabel': 'Choroby wątroby',
            'diseaseDescription': '(stłuszczenie, WZW, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'fatty_liver', 'label': 'Stłuszczenie wątroby'},
              {'value': 'hepatitis', 'label': 'Wirusowe zapalenie wątroby (WZW)'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby nerek
        SurveyQuestionEntity(
          id: 'somatic_kidney',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'kidney',
            'diseaseLabel': 'Choroby nerek',
            'diseaseDescription': '(przewlekła choroba nerek, kamica nerkowa, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'ckd', 'label': 'Przewlekła choroba nerek'},
              {'value': 'stones', 'label': 'Kamica nerkowa'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby nowotworowe
        SurveyQuestionEntity(
          id: 'somatic_cancer',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'cancer',
            'diseaseLabel': 'Choroby nowotworowe',
            'diseaseDescription': '(aktywne, w wywiadzie, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'active', 'label': 'Nowotwór aktywny'},
              {'value': 'history', 'label': 'Nowotwór w wywiadzie'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Przewlekłe choroby bólowe
        SurveyQuestionEntity(
          id: 'somatic_chronic_pain',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'chronic_pain',
            'diseaseLabel': 'Przewlekłe choroby bólowe',
            'diseaseDescription': '(fibromialgia, ból kręgosłupa, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'fibromyalgia', 'label': 'Fibromialgia'},
              {'value': 'back_pain', 'label': 'Przewlekły ból kręgosłupa'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Choroby dermatologiczne
        SurveyQuestionEntity(
          id: 'somatic_dermatological',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'dermatological',
            'diseaseLabel': 'Choroby dermatologiczne',
            'diseaseDescription': '(AZS, łuszczyca, trądzik przewlekły, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'atopic_dermatitis', 'label': 'AZS'},
              {'value': 'psoriasis', 'label': 'Łuszczyca'},
              {'value': 'chronic_acne', 'label': 'Trądzik przewlekły'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Alergie
        SurveyQuestionEntity(
          id: 'somatic_allergies',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'allergies',
            'diseaseLabel': 'Alergie',
            'diseaseDescription': '(wziewne, pokarmowe, kontaktowe, leki, inne)',
            'hasDontKnow': true,
            'subtypes': [
              {'value': 'inhalant', 'label': 'Wziewne'},
              {'value': 'food', 'label': 'Pokarmowe'},
              {'value': 'contact', 'label': 'Kontaktowe'},
              {'value': 'drugs', 'label': 'Leki'},
              {'value': 'other', 'label': 'Inne', 'allowFreeText': true},
            ],
          },
        ),
        // Inne choroby somatyczne
        SurveyQuestionEntity(
          id: 'somatic_other',
          type: QuestionType.boolean,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza) któreś z poniższych schorzeń?',
          required: true,
          options: {
            'composite': 'somatic_disease',
            'rowKey': 'other',
            'diseaseLabel': 'Inne choroby somatyczne',
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

