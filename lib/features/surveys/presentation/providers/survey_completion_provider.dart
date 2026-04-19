import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/core/providers/notification_service_provider.dart';
import 'package:braves_cog/features/surveys/config/survey_schedule_config.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_availability.dart';
import 'package:braves_cog/features/surveys/presentation/providers/survey_provider.dart';
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
    final notificationId = _notificationId(surveyType);
    if (notificationId == null) return;

    final interval = _interval(surveyType);
    DateTime? nextDue;

    if (surveyType == SurveyScheduleConfig.monitoring) {
      final userId = _ref.read(authProvider).user?.id;
      if (userId != null) {
        final onboardingAnchor = await _latestCompletionBySurveyType(
          userId: userId,
          surveyType: 'onboarding',
        );
        if (onboardingAnchor != null) {
          nextDue = _nextMonitoringDue(
            onboardingAnchor: onboardingAnchor,
            lastCompletedAt: completedAt,
          );
        }
      }
    }

    nextDue ??= (interval != null) ? completedAt.add(interval) : null;
    if (nextDue == null) return;

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

/// ─── AVAILABILITY REFRESH TRIGGER (Manual, Event-Driven) ───

/// Notifier that triggers availability refresh on demand.
/// Replaces the 30-second clock with event-driven updates.
class AvailabilityRefreshNotifier extends StateNotifier<int> {
  AvailabilityRefreshNotifier() : super(0);

  /// Trigger a refresh by incrementing the counter.
  /// All providers watching this will re-evaluate.
  void triggerRefresh() {
    debugPrint(
      '🔄 [AvailabilityRefreshNotifier] Triggering availability refresh',
    );
    state = state + 1;
  }
}

/// Refresh trigger provider - watch this to invalidate availability caches.
/// Only fires when explicitly triggered via triggerRefresh().
final availabilityRefreshProvider =
    StateNotifierProvider<AvailabilityRefreshNotifier, int>(
      (ref) => AvailabilityRefreshNotifier(),
    );

DateTime? _maxDate(DateTime? a, DateTime? b) {
  if (a == null) return b;
  if (b == null) return a;
  return a.isAfter(b) ? a : b;
}

DateTime _dateAtStartOfDay(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

int _daysSinceAnchor(DateTime anchor, DateTime point) {
  final a = _dateAtStartOfDay(anchor);
  final p = _dateAtStartOfDay(point);
  return p.difference(a).inDays;
}

DateTime _monitoringDayFromAnchor(DateTime onboardingAnchor, int dayOffset) {
  return _dateAtStartOfDay(onboardingAnchor).add(Duration(days: dayOffset));
}

DateTime _nextMonitoringDue({
  required DateTime onboardingAnchor,
  DateTime? lastCompletedAt,
}) {
  final reference = lastCompletedAt ?? onboardingAnchor;
  final elapsedDays = _daysSinceAnchor(onboardingAnchor, reference);

  // Monitoring cadence per protocol: day 6 and day 18 within each 30-day cycle.
  // Global offsets from baseline are: 6, 18, 36, 48, 66, 78, ...
  var cycle = elapsedDays ~/ 30;
  while (true) {
    final day6 = (30 * cycle) + 6;
    final day18 = (30 * cycle) + 18;

    if (day6 > elapsedDays) {
      return _monitoringDayFromAnchor(onboardingAnchor, day6);
    }
    if (day18 > elapsedDays) {
      return _monitoringDayFromAnchor(onboardingAnchor, day18);
    }
    cycle++;
  }
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
  ref.watch(availabilityRefreshProvider);
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
  ref.watch(availabilityRefreshProvider);
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
  ref.watch(availabilityRefreshProvider);
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
  ref.watch(availabilityRefreshProvider);
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
  final onboardingAnchor = ref
      .watch(_latestOnboardingCompletionProvider)
      .valueOrNull;
  final effectiveLastCompleted = _maxDate(local, remote);

  if (onboardingAnchor != null) {
    final nextAvailableAt = _nextMonitoringDue(
      onboardingAnchor: onboardingAnchor,
      lastCompletedAt: effectiveLastCompleted,
    );
    return SurveyAvailability(
      isAvailable: DateTime.now().isAfter(nextAvailableAt),
      nextAvailableAt: nextAvailableAt,
    );
  }

  // Fallback for edge cases when onboarding anchor is not available.
  return _computeAvailability(
    effectiveLastCompleted,
    SurveyScheduleConfig.monitoringInterval,
  );
});

/// Check if all required surveys for screening flow are completed today.
final _isScreeningCompletedTodayProvider = FutureProvider<bool>((ref) async {
  ref.watch(availabilityRefreshProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return false;

  final datasource = ref.watch(surveyRemoteDataSourceProvider);
  return datasource.isFlowCompletedToday(
    userId: userId,
    flowType: SurveyScheduleConfig.screening,
  );
});

/// Check if user has started ANY follow-up surveys today (even if not completed).
/// Used to allow users to continue partial follow-up sessions.
final _isFollowUpStartedTodayProvider = FutureProvider<bool>((ref) async {
  ref.watch(availabilityRefreshProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return false;

  final datasource = ref.watch(surveyRemoteDataSourceProvider);
  return datasource.isFlowStartedToday(
    userId: userId,
    flowType: SurveyScheduleConfig.followUp,
  );
});

final screeningAvailabilityProvider = Provider<SurveyAvailability>((ref) {
  final local = ref.watch(
    surveyCompletionProvider,
  )[SurveyScheduleConfig.screening];
  final remote = ref.watch(_latestScreeningCompletionProvider).valueOrNull;
  final effectiveLastCompleted = _maxDate(local, remote);
  final scheduledAvailability = _computeAvailability(
    effectiveLastCompleted,
    SurveyScheduleConfig.screeningInterval,
  );

  // Check if flow is completed today
  final isCompletedToday =
      ref.watch(_isScreeningCompletedTodayProvider).valueOrNull ?? false;

  // Enable if scheduled OR if not completed (partial completion case)
  final finalAvailability =
      scheduledAvailability.isAvailable || !isCompletedToday;

  return SurveyAvailability(
    isAvailable: finalAvailability,
    nextAvailableAt: scheduledAvailability.nextAvailableAt,
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

  final scheduledAvailability = _computeAvailability(
    anchor,
    SurveyScheduleConfig.followUpInterval,
  );

  // Check if user has started (but not necessarily completed) follow-up today
  final isStartedToday =
      ref.watch(_isFollowUpStartedTodayProvider).valueOrNull ?? false;

  // Enable if scheduled by time, OR if user already started it today (partial completion)
  final finalAvailability = scheduledAvailability.isAvailable || isStartedToday;

  return SurveyAvailability(
    isAvailable: finalAvailability,
    nextAvailableAt: scheduledAvailability.nextAvailableAt,
  );
});

/// Count submitted surveys for screening flow today.
final screeningSubmittedCountProvider = FutureProvider<int>((ref) async {
  ref.watch(availabilityRefreshProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return 0;

  final datasource = ref.watch(surveyRemoteDataSourceProvider);
  final submitted = await datasource.getCompletedSurveyAnswersByType(
    userId: userId,
    surveyType: SurveyScheduleConfig.screening,
  );
  return submitted.length;
});

/// Count submitted surveys for follow-up flow today.
final followupSubmittedCountProvider = FutureProvider<int>((ref) async {
  ref.watch(availabilityRefreshProvider);
  final userId = ref.watch(authProvider).user?.id;
  if (userId == null) return 0;

  final datasource = ref.watch(surveyRemoteDataSourceProvider);
  final submitted = await datasource.getCompletedSurveyAnswersByType(
    userId: userId,
    surveyType: SurveyScheduleConfig.followUp,
  );
  return submitted.length;
});
