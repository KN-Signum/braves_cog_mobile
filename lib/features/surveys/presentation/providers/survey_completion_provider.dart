import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/notification_service_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_schedule_config.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_availability.dart';

/// In-memory store of [surveyType] → [lastCompletedAt].
/// All data is lost when the app is terminated — this is intentional for
/// the early development stage. Replace with a persistent datasource later.
class SurveyCompletionNotifier extends StateNotifier<Map<String, DateTime>> {
  final Ref _ref;

  SurveyCompletionNotifier(this._ref) : super({});

  /// Records a completion for [surveyType] and schedules the next notification.
  /// State is updated synchronously; notification scheduling is fire-and-forget.
  void recordCompletion(String surveyType) {
    final completedAt = DateTime.now();
    state = {...state, surveyType: completedAt};
    _scheduleNextNotification(surveyType, completedAt);
  }

  Future<void> _scheduleNextNotification(
    String surveyType,
    DateTime completedAt,
  ) async {
    final interval = _interval(surveyType);
    final notificationId = _notificationId(surveyType);
    if (interval == null || notificationId == null) return;

    final nextDue = completedAt.add(interval);
    final notificationService = _ref.read(notificationServiceProvider);

    // Cancel previous notification for this type before rescheduling.
    await notificationService.cancelNotification(notificationId);
    await notificationService.scheduleNotification(
      id: notificationId,
      title: _notificationTitle(surveyType),
      body: _notificationBody(surveyType),
      scheduledDateTime: nextDue,
    );
  }

  Duration? _interval(String surveyType) {
    switch (surveyType) {
      case SurveyScheduleConfig.monitoring:
        return SurveyScheduleConfig.monitoringInterval;
      case SurveyScheduleConfig.screening:
        return SurveyScheduleConfig.screeningInterval;
      // TODO(follow-up): add follow-up intervals when implemented
      // case SurveyScheduleConfig.followUp1:
      //   return SurveyScheduleConfig.followUp1Interval;
      // case SurveyScheduleConfig.followUp2:
      //   return SurveyScheduleConfig.followUp2Interval;
      default:
        return null;
    }
  }

  int? _notificationId(String surveyType) {
    switch (surveyType) {
      case SurveyScheduleConfig.monitoring:
        return SurveyScheduleConfig.monitoringNotificationId;
      case SurveyScheduleConfig.screening:
        return SurveyScheduleConfig.screeningNotificationId;
      // TODO(follow-up): add follow-up notification IDs when implemented
      // case SurveyScheduleConfig.followUp1:
      //   return SurveyScheduleConfig.followUp1NotificationId;
      // case SurveyScheduleConfig.followUp2:
      //   return SurveyScheduleConfig.followUp2NotificationId;
      default:
        return null;
    }
  }

  String _notificationTitle(String surveyType) {
    switch (surveyType) {
      case SurveyScheduleConfig.monitoring:
        return 'Czas na monitoring!';
      case SurveyScheduleConfig.screening:
        return 'Czas na screening!';
      // TODO(follow-up): add follow-up titles when implemented
      default:
        return 'Czas na ankietę!';
    }
  }

  String _notificationBody(String surveyType) {
    switch (surveyType) {
      case SurveyScheduleConfig.monitoring:
        return 'Uzupełnij badanie samopoczucia.';
      case SurveyScheduleConfig.screening:
        return 'Wypełnij miesięczną ocenę zdrowia.';
      // TODO(follow-up): add follow-up bodies when implemented
      default:
        return 'Wypełnij ankietę.';
    }
  }
}

/// In-memory completion timestamps, keyed by survey type string.
final surveyCompletionProvider =
    StateNotifierProvider<SurveyCompletionNotifier, Map<String, DateTime>>(
      (ref) => SurveyCompletionNotifier(ref),
    );

/// Periodic clock that ticks every 30 seconds.
/// Availability providers watch this so they re-evaluate [DateTime.now()]
/// automatically once the interval has elapsed, without requiring any user action.
final _availabilityClockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

SurveyAvailability _computeAvailability(
  Map<String, DateTime> completions,
  String surveyType,
  Duration interval,
) {
  final lastCompleted = completions[surveyType];
  if (lastCompleted == null) {
    return const SurveyAvailability(isAvailable: true);
  }
  final nextAvailableAt = lastCompleted.add(interval);
  return SurveyAvailability(
    isAvailable: DateTime.now().isAfter(nextAvailableAt),
    nextAvailableAt: nextAvailableAt,
  );
}

final monitoringAvailabilityProvider = Provider<SurveyAvailability>((ref) {
  // Watch the clock so this provider rebuilds every 30 s.
  ref.watch(_availabilityClockProvider);
  final completions = ref.watch(surveyCompletionProvider);
  return _computeAvailability(
    completions,
    SurveyScheduleConfig.monitoring,
    SurveyScheduleConfig.monitoringInterval,
  );
});

final screeningAvailabilityProvider = Provider<SurveyAvailability>((ref) {
  // Watch the clock so this provider rebuilds every 30 s.
  ref.watch(_availabilityClockProvider);
  final completions = ref.watch(surveyCompletionProvider);
  return _computeAvailability(
    completions,
    SurveyScheduleConfig.screening,
    SurveyScheduleConfig.screeningInterval,
  );
});

// TODO(follow-up): add availability providers when follow-up surveys are implemented
// final followUp1AvailabilityProvider = Provider<SurveyAvailability>((ref) {
//   final completions = ref.watch(surveyCompletionProvider);
//   return _computeAvailability(
//     completions,
//     SurveyScheduleConfig.followUp1,
//     SurveyScheduleConfig.followUp1IntervalDays,
//   );
// });
// final followUp2AvailabilityProvider = Provider<SurveyAvailability>((ref) {
//   final completions = ref.watch(surveyCompletionProvider);
//   return _computeAvailability(
//     completions,
//     SurveyScheduleConfig.followUp2,
//     SurveyScheduleConfig.followUp2IntervalDays,
//   );
// });
