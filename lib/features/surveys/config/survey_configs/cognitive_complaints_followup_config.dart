import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class CognitiveComplaintsFollowUpSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'CognitiveComplaintsFollowUpSurveyConfig',
      title: 'Followup',
      questions: [
        SurveyQuestionEntity(
          id: 'ccf_info',
          type: QuestionType.text,
          question: 'Funkcje poznawcze — ocena szczegółowa',
          description:
              'W tej sekcji prosimy o bardziej szczegółową ocenę ewentualnych trudności z pamięcią, koncentracją i myśleniem.\n\n'
              'Porównaj swoje obecne funkcjonowanie z tym sprzed roku (lub sprzed rozpoczęcia badania).\n\n'
              'Szacowany czas: ok. 3–5 minuty.',
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_forgetting',
          type: QuestionType.choice,
          question:
              'Zapominanie / Problemy z pamięcią',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_concentration',
          type: QuestionType.choice,
          question:
              'Słaba koncentracja',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_expressing_thoughts',
          type: QuestionType.choice,
          question:
              'Trudności w wyrażaniu myśli',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_finding_words',
          type: QuestionType.choice,
          question:
              'Trudność w znalezieniu właściwego słowa',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_slowed_thinking',
          type: QuestionType.choice,
          question:
              'Spowolnione tempo myślenia',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        SurveyQuestionEntity(
          id: 'ccf_rating_problem_solving',
          type: QuestionType.choice,
          question:
              'Trudności z rozwiązywaniem problemów lub „rozgryzaniem” rzeczy',
          required: true,
          options: {
            'options': [
              {'value': '0', 'label': 'Brak'},
              {'value': '1', 'label': 'Niewielkie'},
              {'value': '2', 'label': 'Dość nasilone'},
              {'value': '3', 'label': 'Bardzo nasilone'},
            ],
          },
        ),
        // Info page for second part
        SurveyQuestionEntity(
          id: 'ccf_info_part2',
          type: QuestionType.text,
          question: 'Proszę odpowiedzieć na poniższe pytania, biorąc pod uwagę ostatnie 30 dni\n\n',
          description: 'Zaznacz jedną odpowiedź dla każdego pytania.',
          required: false,
          options: {
            'info': true, 
            'intro': true,
          },
        ),
        // Q1: Impact on work
        SurveyQuestionEntity(
          id: 'ccf_impact_work',
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
          id: 'ccf_impact_relationships',
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
          id: 'ccf_impact_hobbies',
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

