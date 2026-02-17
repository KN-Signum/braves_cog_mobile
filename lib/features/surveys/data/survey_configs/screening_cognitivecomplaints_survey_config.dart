import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningCognitiveComplaintsSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'BC-CCI-E',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'cc_rating',
          type: QuestionType.table,
          question: 'Proszę ocenić swoje problemy z koncentracją, pamięcią i myśleniem w ciągu ostatnich 30 dni.',
          description: 'Skala odpowiedzi:\n0 = brak\n1 = niewielkie\n2 = dość nasilone\n3 = bardzo nasilone',
          required: true,
          options: {
            'rows': [
              {
                'value': 'forgetting',
                'label': 'Zapominanie / Problemy z pamięcią',
              },
              {
                'value': 'concentration',
                'label': 'Słaba koncentracja',
              },
              {
                'value': 'expressing_thoughts',
                'label': 'Trudności w wyrażaniu myśli',
              },
              {
                'value': 'finding_words',
                'label': 'Trudność w znalezieniu właściwego słowa',
              },
              {
                'value': 'slowed_thinking',
                'label': 'Spowolnione tempo myślenia',
              },
              {
                'value': 'problem_solving',
                'label': 'Trudności z rozwiązywaniem problemów lub „rozgryzaniem” rzeczy',
              },
            ],
            'columns': [
              {'value': '0', 'label': '0'},
              {'value': '1', 'label': '1'},
              {'value': '2', 'label': '2'},
              {'value': '3', 'label': '3'},
            ],
            'rowLabels': {
              'forgetting': 'Zapominanie / Problemy z pamięcią',
              'concentration': 'Słaba koncentracja',
              'expressing_thoughts': 'Trudności w wyrażaniu myśli',
              'finding_words': 'Trudność w znalezieniu właściwego słowa',
              'slowed_thinking': 'Spowolnione tempo myślenia',
              'problem_solving': 'Trudności z rozwiązywaniem problemów lub „rozgryzaniem” rzeczy',
            },
            'columnLabels': {
              '0': '0',
              '1': '1',
              '2': '2',
              '3': '3',
            },
          },
        ),
        // Info page for second part
        SurveyQuestionEntity(
          id: 'cc_info_part2',
          type: QuestionType.text,
          question: 'Proszę odpowiedzieć na poniższe pytania, biorąc pod uwagę ostatnie 30 dni.\n\nZaznacz jedną odpowiedź.',
          required: false,
          options: {
            'info': true, // This is an info-only question, no input needed
          },
        ),
        // Q1: Impact on work
        SurveyQuestionEntity(
          id: 'cc_impact_work',
          type: QuestionType.choice,
          question: 'Wymienione powyżej objawy utrudniają mi wykonywanie pracy\n(jeśli obecnie nie pracujesz – odpowiedz, odnosząc się do ostatniej pracy lub szkoły)',
          required: true,
          options: {
            'options': [
              {'value': 'completely_false', 'label': 'Fałsz / Wcale nieprawda'},
              {'value': 'rather_false', 'label': 'Raczej nieprawda'},
              {'value': 'somewhat_true', 'label': 'Trochę prawda'},
              {'value': 'mostly_true', 'label': 'W większości prawda'},
              {'value': 'completely_true', 'label': 'Całkowita prawda'},
            ],
          },
        ),
        // Q2: Impact on relationships
        SurveyQuestionEntity(
          id: 'cc_impact_relationships',
          type: QuestionType.choice,
          question: 'Wymienione powyżej objawy utrudniają mi utrzymywanie dobrych relacji z rodziną i przyjaciółmi',
          required: true,
          options: {
            'options': [
              {'value': 'completely_false', 'label': 'Fałsz / Wcale nieprawda'},
              {'value': 'rather_false', 'label': 'Raczej nieprawda'},
              {'value': 'somewhat_true', 'label': 'Trochę prawda'},
              {'value': 'mostly_true', 'label': 'W większości prawda'},
              {'value': 'completely_true', 'label': 'Całkowita prawda'},
            ],
          },
        ),
        // Q3: Impact on hobbies
        SurveyQuestionEntity(
          id: 'cc_impact_hobbies',
          type: QuestionType.choice,
          question: 'Wymienione powyżej objawy utrudniają mi czerpanie przyjemności z aktywności społecznych, rekreacyjnych lub hobby',
          required: true,
          options: {
            'options': [
              {'value': 'completely_false', 'label': 'Fałsz / Wcale nieprawda'},
              {'value': 'rather_false', 'label': 'Raczej nieprawda'},
              {'value': 'somewhat_true', 'label': 'Trochę prawda'},
              {'value': 'mostly_true', 'label': 'W większości prawda'},
              {'value': 'completely_true', 'label': 'Całkowita prawda'},
            ],
          },
        ),
      ],
    );
  }
}

