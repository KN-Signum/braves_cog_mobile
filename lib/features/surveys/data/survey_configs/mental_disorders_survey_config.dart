import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class MentalDisordersSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'Baseline_Mental_Health_Disorders',
      title: 'Zaburzenia psychiczne',
      questions: [
        SurveyQuestionEntity(
          id: 'mental_disorders',
          type: QuestionType.table,
          question: 'Czy kiedykolwiek rozpoznano u Ciebie (przez lekarza lub psychologa) któreś z poniższych zaburzeń?',
          required: true,
          options: {
            'rows': [
              {
                'value': 'depression',
                'label': 'Depresja',
              },
              {
                'value': 'anxiety',
                'label': 'Zaburzenia lękowe\n(np. lęk uogólniony, napady paniki, fobie)',
              },
              {
                'value': 'adhd',
                'label': 'ADHD',
              },
              {
                'value': 'asd',
                'label': 'Zaburzenia ze spektrum autyzmu (ASD)',
              },
              {
                'value': 'bipolar',
                'label': 'Choroba afektywna dwubiegunowa',
              },
              {
                'value': 'psychotic',
                'label': 'Zaburzenia psychotyczne\n(np. schizofrenia)',
              },
              {
                'value': 'ocd',
                'label': 'Zaburzenia obsesyjno-kompulsyjne (OCD)',
              },
              {
                'value': 'ptsd',
                'label': 'Zespół stresu pourazowego (PTSD)',
              },
              {
                'value': 'eating',
                'label': 'Zaburzenia odżywiania\n(anoreksja, bulimia, BED)',
              },
              {
                'value': 'sleep',
                'label': 'Zaburzenia snu\n(bezsenność, hipersomnia – jako rozpoznanie)',
              },
              {
                'value': 'substance',
                'label': 'Uzależnienie / zaburzenia używania substancji',
              },
              {
                'value': 'personality',
                'label': 'Zaburzenia osobowości\n(np. borderline, narcystyczne, unikające)',
              },
              {
                'value': 'other',
                'label': 'Inne zaburzenie psychiczne',
              },
            ],
            'columns': [
              {'value': 'yes', 'label': 'Tak'},
              {'value': 'no', 'label': 'Nie'},
              {'value': 'dont_know', 'label': 'Nie wiem'},
            ],
            'rowLabels': {
              'depression': 'Depresja',
              'anxiety': 'Zaburzenia lękowe',
              'adhd': 'ADHD',
              'asd': 'Zaburzenia ze spektrum autyzmu (ASD)',
              'bipolar': 'Choroba afektywna dwubiegunowa',
              'psychotic': 'Zaburzenia psychotyczne',
              'ocd': 'Zaburzenia obsesyjno-kompulsyjne (OCD)',
              'ptsd': 'Zespół stresu pourazowego (PTSD)',
              'eating': 'Zaburzenia odżywiania',
              'sleep': 'Zaburzenia snu',
              'substance': 'Uzależnienie / zaburzenia używania substancji',
              'personality': 'Zaburzenia osobowości',
              'other': 'Inne zaburzenie psychiczne',
            },
            'columnLabels': {
              'yes': 'Tak',
              'no': 'Nie',
              'dont_know': 'Nie wiem',
            },
          },
        ),
        SurveyQuestionEntity(
          id: 'mental_other_description',
          type: QuestionType.text,
          question: 'Jeśli wybrałeś/-aś "Inne zaburzenie psychiczne", opisz jakie:',
          required: false,
          options: {
            'multiline': true,
            'placeholder': 'Opisz inne zaburzenie psychiczne...',
          },
          conditionalLogic: {
            'showIf': {
              'questionId': 'mental_disorders_other',
              'operator': '==',
              'value': 'yes',
            },
          },
        ),
      ],
    );
  }
}

