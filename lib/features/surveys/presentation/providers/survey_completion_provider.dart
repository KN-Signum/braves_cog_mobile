import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/core/providers/notification_service_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_schedule_config.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_availability.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory store of [surveyType] -> [lastCompletedAt].
/// This is used as immediate optimistic state after completion.
/// Availability is reconciled against backend submission timestamps.
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
      case SurveyScheduleConfig.followUp:
        return SurveyScheduleConfig.followUpInterval;
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
      case SurveyScheduleConfig.followUp:
        return SurveyScheduleConfig.followUpNotificationId;
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
      case SurveyScheduleConfig.followUp:
        return 'Czas na follow-up!';
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
      case SurveyScheduleConfig.followUp:
        return 'Wypełnij ankietę follow-up.';
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

DateTime? _maxDate(DateTime? a, DateTime? b) {
  if (a == null) return b;
  if (b == null) return a;
  return a.isAfter(b) ? a : b;
}

Future<DateTime?> _latestCompletionBySurveyIds({
  required String userId,
  required List<String> surveyIds,
}) async {
  if (surveyIds.isEmpty) return null;

  final response = await Supabase.instance.client
      .from('survey_responses')
      .select('completed_at')
      .eq('user_id', userId)
      .inFilter('survey_id', surveyIds)
      .order('completed_at', ascending: false)
      .limit(1)
      .maybeSingle();

  final raw = response?['completed_at']?.toString();
  return raw == null ? null : DateTime.tryParse(raw)?.toUtc();
}

Future<DateTime?> _latestCompletionBySurveyKeys({
  required String userId,
  required List<String> surveyKeys,
}) async {
  if (surveyKeys.isEmpty) return null;

  final surveys = await Supabase.instance.client
      .from('surveys')
      .select('id')
      .inFilter('survey_key', surveyKeys)
      .eq('is_active', true);

  final ids = surveys
      .map((row) => row['id']?.toString())
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toList();

  return _latestCompletionBySurveyIds(userId: userId, surveyIds: ids);
}

Future<DateTime?> _latestCompletionBySurveyType({
  required String userId,
  required String surveyType,
}) async {
  final surveys = await Supabase.instance.client
      .from('surveys')
      .select('id')
      .eq('survey_type', surveyType)
      .eq('is_active', true);

  final ids = surveys
      .map((row) => row['id']?.toString())
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toList();

  return _latestCompletionBySurveyIds(userId: userId, surveyIds: ids);
}

Future<DateTime?> _latestCompletionByTypeWithFallbackKeys({
  required String userId,
  required String surveyType,
  required List<String> fallbackKeys,
}) async {
  final byType = await _latestCompletionBySurveyType(
    userId: userId,
    surveyType: surveyType,
  );
  if (byType != null) return byType;
  return _latestCompletionBySurveyKeys(
    userId: userId,
    surveyKeys: fallbackKeys,
  );
}

final _latestMonitoringCompletionProvider = FutureProvider<DateTime?>((
  ref,
) async {
  ref.watch(_availabilityClockProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return null;

  return _latestCompletionByTypeWithFallbackKeys(
    userId: userId,
    surveyType: SurveyScheduleConfig.monitoring,
    fallbackKeys: SurveyScheduleConfig.monitoringSurveyKeys,
  );
});

final _latestScreeningCompletionProvider = FutureProvider<DateTime?>((
  ref,
) async {
  ref.watch(_availabilityClockProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return null;

  return _latestCompletionByTypeWithFallbackKeys(
    userId: userId,
    surveyType: SurveyScheduleConfig.screening,
    fallbackKeys: SurveyScheduleConfig.screeningSurveyKeys,
  );
});

final _latestFollowUpCompletionProvider = FutureProvider<DateTime?>((
  ref,
) async {
  ref.watch(_availabilityClockProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return null;

  return _latestCompletionByTypeWithFallbackKeys(
    userId: userId,
    surveyType: SurveyScheduleConfig.followUp,
    fallbackKeys: SurveyScheduleConfig.followUpSurveyKeys,
  );
});

final _latestOnboardingCompletionProvider = FutureProvider<DateTime?>((
  ref,
) async {
  ref.watch(_availabilityClockProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return null;

  return _latestCompletionBySurveyType(
    userId: userId,
    surveyType: 'onboarding',
  );
});

SurveyAvailability _computeAvailability(
  DateTime? lastCompletedAt,
  Duration interval,
) {
  final lastCompleted = lastCompletedAt;
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
  final local = ref.watch(
    surveyCompletionProvider,
  )[SurveyScheduleConfig.monitoring];
  final remote = ref.watch(_latestMonitoringCompletionProvider).valueOrNull;
  final effectiveLastCompleted = _maxDate(local, remote);
  return _computeAvailability(
    effectiveLastCompleted,
    SurveyScheduleConfig.monitoringInterval,
  );
});

final screeningAvailabilityProvider = Provider<SurveyAvailability>((ref) {
  final local = ref.watch(
    surveyCompletionProvider,
  )[SurveyScheduleConfig.screening];
  final remote = ref.watch(_latestScreeningCompletionProvider).valueOrNull;
  final effectiveLastCompleted = _maxDate(local, remote);
  return _computeAvailability(
    effectiveLastCompleted,
    SurveyScheduleConfig.screeningInterval,
  );
});

/// Follow-up schedule:
/// - First follow-up: 180 days from latest onboarding submission.
/// - Next follow-ups: every 180 days from latest follow-up submission.
final followUpAvailabilityProvider = Provider<SurveyAvailability>((ref) {
  final localFollowUp = ref.watch(
    surveyCompletionProvider,
  )[SurveyScheduleConfig.followUp];
  final remoteFollowUp = ref
      .watch(_latestFollowUpCompletionProvider)
      .valueOrNull;
  final remoteOnboarding = ref
      .watch(_latestOnboardingCompletionProvider)
      .valueOrNull;

  final latestFollowUp = _maxDate(localFollowUp, remoteFollowUp);
  final anchor = latestFollowUp ?? remoteOnboarding;

  return _computeAvailability(anchor, SurveyScheduleConfig.followUpInterval);
});
