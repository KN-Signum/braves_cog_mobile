import 'package:braves_cog/features/profile/domain/entities/user_type.dart';

import 'survey_configs/demographic_survey_config.dart';
import 'survey_configs/ipaq_survey_config.dart';
import 'survey_configs/screening_sq_survey_config.dart';
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

import 'survey_configs/screening_pa_survey_config.dart';
import 'survey_configs/screening_cognitivecomplaints_survey_config.dart';
import 'survey_configs/screening_diet_survey_config.dart';
import 'survey_configs/gad_2_survey_config.dart';
import 'survey_configs/phq_2_survey_config.dart';

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
            'config': ScreeningSQSurveyConfig.getSurvey(),
          },
          {
            'id': 'Baseline_Eating_Habits',
            'config': MiniEatSurveyConfig.getSurvey(),
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
