/// Defines survey type identifiers and scheduling rules (intervals, notification IDs).
class SurveyScheduleConfig {
  // --- Survey type keys ---
  static const String monitoring = 'monitoring';
  static const String screening = 'screening';
  // TODO(follow-up): add follow-up survey types when implemented
  // static const String followUp1 = 'follow_up_1';
  // static const String followUp2 = 'follow_up_2';

  // --- Repeat intervals ---
  static const Duration monitoringInterval = Duration(days: 15);
  static const Duration screeningInterval = Duration(days: 30);

  // TODO(follow-up): follow-up intervals
  // static const Duration followUp1Interval = Duration(days: 180);
  // static const Duration followUp2Interval = Duration(days: 360);

  // --- Deterministic notification IDs ---
  static const int monitoringNotificationId = 1001;
  static const int screeningNotificationId = 1002;
  // TODO(follow-up): follow-up notification IDs
  // static const int followUp1NotificationId = 1003;
  // static const int followUp2NotificationId = 1004;
}
