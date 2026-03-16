import 'package:braves_cog/features/profile/domain/entities/user_type.dart';

import 'package:braves_cog/features/surveys/domain/entities/survey_entity.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_question_entity.dart';

import 'survey_configs/demographic_survey_config.dart';
import 'survey_configs/ipaq_survey_config.dart';
import 'survey_configs/screening_sq_survey_config.dart';
import 'survey_configs/onboarding_sq_survey_config.dart';
import 'survey_configs/mini_eat_survey_config.dart';
import 'survey_configs/screening_su_survey_config.dart';
import 'survey_configs/brief_2way_sss_survey_config.dart';
import 'survey_configs/aq_survey_config.dart';
import 'survey_configs/gad_7_survey_config.dart';
import 'survey_configs/pss_10_survey_config.dart';
import 'survey_configs/phq_9_survey_config.dart';
import 'survey_configs/somatic_diseases_survey_config.dart';
import 'survey_configs/mental_disorders_survey_config.dart';
import 'survey_configs/medications_survey_config.dart';
import 'survey_configs/mini_eat_onboarding.dart';

import 'survey_configs/screening_pa_survey_config.dart';
import 'survey_configs/screening_cognitivecomplaints_survey_config.dart';
import 'survey_configs/screening_diet_survey_config.dart';
import 'survey_configs/gad_2_survey_config.dart';
import 'survey_configs/phq_2_survey_config.dart';
import 'survey_configs/asrs_survey_config.dart' as asrs_config;
import 'survey_configs/cognitive_complaints_followup_config.dart';

class SurveyFlowRules {
  /// Returns the modules for onboarding based on the user's patient type.
  /// You can add logic here to filter modules or surveys based on [userType].
  static List<Map<String, dynamic>> getOnboardingModules(UserType userType) {
    // For now, return all surveys for all user types.
    // To block a survey for a specific patient type, you can use if statements:
    // if (userType == UserType.vasCog) { ... remove or do not add ... }

    return [
      {
        'id': 'Demographic',
        'name': 'Dane demograficzne',
        'surveys': [
          {'id': 'Demographic', 'config': DemographicSurveyConfig.getSurvey()},
        ],
      },
      {
        'id': 'Baseline_Lifestyle',
        'name': 'Styl życia',
        'surveys': [
          {
            'id': 'Baseline_Physical_Activity',
            'config': IPAQSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Sleep_Quality',
            'config': OnboardingSqSurveyConfig.getSurvey(),
          },
          {
            'id': 'MINI_EAT_OB',
            'config': MiniEatOnboardingSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Substance_Use',
            'config': ScreeningSUSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Social_Support',
            'config': Brief2WaySSSSurveyConfig.getSurvey(),
          },
        ],
      },
      {
        'id': 'Baseline_Symptoms',
        'name': 'Profil psychologiczny',
        'surveys': [
          {'id': 'Baseline_ASD', 'config': AQSurveyConfig.getSurvey()},
          {
            'id': 'Baseline_Stress_And_Anxiety_GAD7',
            'config': GAD7SurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Stress_And_Anxiety_PSS10',
            'config': PSS10SurveyConfig.getSurvey(),
          },
          {'id': 'Baseline_Depression', 'config': PHQ9SurveyConfig.getSurvey()},
        ],
      },
      {
        'id': 'Baseline_Medical_History',
        'name': 'Informacje zdrowotne',
        'surveys': [
          {
            'id': 'Baseline_Somatic_Disease',
            'config': SomaticDiseasesSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Mental_Health_Disorders',
            'config': MentalDisordersSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Medications',
            'config': MedicationsSurveyConfig.getSurvey(),
          },
        ],
      },
    ];
  }

  /// Returns the surveys for the follow-up flow (tytuł: Follow-up).
  static List<Map<String, dynamic>> getFollowUpSurveys(UserType userType) {
    // Domyślnie używamy konfiguracji dla pierwszego pełnego follow-upu (6 miesięcy).
    return getFirstFollowUpSurveys(userType);
  }

  /// Pierwszy pełny follow-up – po 6 miesiącach.
  static List<Map<String, dynamic>> getFirstFollowUpSurveys(
      UserType userType) {
    final base = _getBaseFollowUpSurveys(userType);
    return [
      {
        'id': 'followup_intro_6m',
        'config': _buildFollowUpIntroSurvey(
          id: 'followup_intro_6m',
          title: 'Minęło 6 miesięcy — czas na przegląd',
          description:
              'Dziękujemy za dotychczasowy udział w badaniu BRAVES Cog. Przez ostatnie pół roku regularnie odpowiadałeś/aś na pytania dotyczące swojego zdrowia i samopoczucia — to bardzo cenne dane.\n\n'
              'Dzisiejsza sesja jest bardziej rozbudowana niż comiesięczne sprawdzenia. Ponownie wypełnisz część kwestionariuszy z początku badania, a także kilka nowych narzędzi.\n\n'
              'Szacowany czas: ok. 30–45 minut.\n\n'
              'Możesz robić przerwy — Twoje odpowiedzi są zapisywane automatycznie.',
        ),
      },
      ...base,
    ];
  }

  /// Drugi pełny follow-up – po 12 miesiącach.
  static List<Map<String, dynamic>> getSecondFollowUpSurveys(
      UserType userType) {
    final base = _getBaseFollowUpSurveys(userType);
    return [
      {
        'id': 'followup_intro_12m',
        'config': _buildFollowUpIntroSurvey(
          id: 'followup_intro_12m',
          title: 'Rok w badaniu — ostatnia pełna sesja',
          description:
              'To już 12 miesięcy od dołączenia do projektu BRAVES Cog. Bardzo dziękujemy za Twój udział i zaangażowanie przez cały ten czas.\n\n'
              'Dzisiejsza sesja jest ostatnią pełną sesją w badaniu. Ponownie wypełnisz kluczowe kwestionariusze, które pozwolą nam ocenić zmiany na przestrzeni roku.\n\n'
              'Szacowany czas: ok. 30–45 minut.\n\n'
              'Twoje odpowiedzi są zapisywane automatycznie — możesz robić przerwy.',
        ),
      },
      ...base,
    ];
  }

  static List<Map<String, dynamic>> _getBaseFollowUpSurveys(
      UserType userType) {
    return [
      {'id': 'followup_IPAQ', 'config': IPAQSurveyConfig.getSurvey()},
      {'id': 'followup_SQ', 'config': ScreeningSQSurveyConfig.getSurvey()},
      {'id': 'MINI_EAT_OB', 'config': MiniEatOnboardingSurveyConfig.getSurvey()},
      {'id': 'followup_SU', 'config': ScreeningSUSurveyConfig.getSurvey()},
      {'id': 'followup_Brief2Way', 'config': Brief2WaySSSSurveyConfig.getSurvey()},
      {'id': 'ASRS', 'config': asrs_config.ASRSSurveyConfig.getSurvey()},
      {'id': 'followup_AQ', 'config': AQSurveyConfig.getSurvey()},
      {'id': 'followup_GAD7', 'config': GAD7SurveyConfig.getSurvey()},
      {'id': 'followup_PSS10', 'config': PSS10SurveyConfig.getSurvey()},
      {'id': 'followup_PHQ9', 'config': PHQ9SurveyConfig.getSurvey()},
      {
        'id': 'followup_BC_CCI',
        'config': CognitiveComplaintsFollowUpSurveyConfig.getSurvey(),
      },
    ];
  }

  static SurveyEntity _buildFollowUpIntroSurvey({
    required String id,
    required String title,
    required String description,
  }) {
    return SurveyEntity(
      id: id,
      title: 'Follow-up',
      questions: [
        SurveyQuestionEntity(
          id: '${id}_info',
          type: QuestionType.text,
          question: title,
          description: description,
          required: false,
          options: {
            'info': true,
            'intro': true,
          },
        ),
      ],
    );
  }

  /// Returns the surveys for the screening flow based on the user's patient type.
  static List<Map<String, dynamic>> getScreeningSurveys(UserType userType) {
    // Similarly, filter specific surveys conditionally relying on [userType].

    return [
      {'id': 'screening_PA', 'config': ScreeningPASurveyConfig.getSurvey()},
      {'id': 'screening_SQ', 'config': ScreeningSQSurveyConfig.getSurvey()},
      {
        'id': 'BC-CCI-E',
        'config': ScreeningCognitiveComplaintsSurveyConfig.getSurvey(),
      },
      {'id': 'screening_SU', 'config': ScreeningSUSurveyConfig.getSurvey()},
      {'id': 'screening_diet', 'config': ScreeningDietSurveyConfig.getSurvey()},
      {'id': 'GAD_2', 'config': GAD2SurveyConfig.getSurvey()},
      {'id': 'PHQ_2', 'config': PHQ2SurveyConfig.getSurvey()},
    ];
  }
}
