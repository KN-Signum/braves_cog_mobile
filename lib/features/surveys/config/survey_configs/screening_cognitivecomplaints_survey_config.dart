import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

class ScreeningCognitiveComplaintsSurveyConfig {
  static SurveyEntity getSurvey() {
    return SurveyEntity(
      id: 'BC-CCI-E',
      title: 'Screening',
      questions: [
        SurveyQuestionEntity(
          id: 'cc_rating_forgetting',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Zapominanie / Problemy z pamięcią.',
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
          id: 'cc_rating_concentration',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Słaba koncentracja.',
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
          id: 'cc_rating_expressing_thoughts',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Trudności w wyrażaniu myśli.',
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
          id: 'cc_rating_finding_words',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Trudność w znalezieniu właściwego słowa.',
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
          id: 'cc_rating_slowed_thinking',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Spowolnione tempo myślenia.',
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
          id: 'cc_rating_problem_solving',
          type: QuestionType.choice,
          question:
              'Proszę ocenić w ciągu ostatnich 30 dni nasilenie objawu: Trudności z rozwiązywaniem problemów lub „rozgryzaniem” rzeczy.',
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

