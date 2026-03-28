/// Defines survey type identifiers and scheduling rules (intervals, notification IDs).
class SurveyScheduleConfig {
  // --- Survey type keys ---
  static const String monitoring = 'monitoring';
  static const String screening = 'screening';
  static const String followUp = 'followup';

  // --- Repeat intervals ---
  static const Duration monitoringInterval = Duration(days: 6);
  static const Duration screeningInterval = Duration(days: 30);
  static const Duration followUpInterval = Duration(days: 180);

  // --- Deterministic notification IDs ---
  static const int monitoringNotificationId = 1001;
  static const int screeningNotificationId = 1002;
  static const int followUpNotificationId = 1003;

  // Fallback key sets used when survey_type mapping is unavailable.
  static const List<String> monitoringSurveyKeys = ['monitoring'];

  static const List<String> screeningSurveyKeys = [
    'screening_PA',
    'screening_SQ',
    'BC-CCI-E',
    'screening_SU',
    'screening_diet',
    'GAD_2',
    'PHQ_2',
    'screening_games_intro',
  ];

  static const List<String> followUpSurveyKeys = [
    'followup_IPAQ',
    'followup_SQ',
    'MINI_EAT_OB',
    'followup_SU',
    'followup_Brief2Way',
    'ASRS',
    'followup_AQ',
    'followup_GAD7',
    'followup_PSS10',
    'followup_PHQ9',
    'followup_BC_CCI',
  ];
}
