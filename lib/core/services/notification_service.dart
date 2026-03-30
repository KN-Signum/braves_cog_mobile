import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service for managing local notifications
/// Handles scheduling, canceling, and configuring notifications for calendar events
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService(this._flutterLocalNotificationsPlugin);

  /// Initialize the notification service with platform-specific settings
  Future<bool> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    final result = await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    return result ?? false;
  }

  /// Check if notification permissions are granted
  Future<bool> areNotificationsEnabled() async {
    // Check iOS permissions
    final iosImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      final settings = await iosImplementation.checkPermissions();
      return settings?.isEnabled ?? false;
    }

    // Check Android permissions
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final bool? result = await androidImplementation
          .areNotificationsEnabled();
      return result ?? false;
    }

    // Default to true if we can't check (shouldn't happen)
    return true;
  }

  /// Request notification permissions (iOS and Android 13+)
  Future<bool> requestPermissions() async {
    // iOS permissions
    final iosResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android 13+ (API 33+) permissions
    final androidResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Android 12+ (API 31+) exact alarm permissions
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      // Request exact alarm permission (for Android 12+)
      final exactAlarmPermission = await androidImplementation
          .requestExactAlarmsPermission();
      print(
        '📱 [NotificationService] Exact alarm permission: $exactAlarmPermission',
      );
    }

    final finalResult = (iosResult ?? true) && (androidResult ?? true);
    print('📱 [NotificationService] Permissions granted: $finalResult');
    return finalResult;
  }

  /// Schedule a notification for a calendar event
  ///
  /// [id] - Unique identifier for the notification (use event ID)
  /// [title] - Notification title
  /// [body] - Notification body/description
  /// [scheduledDateTime] - When the notification should be shown
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    print('⏰ [NotificationService] Scheduling notification...');
    print('   ID: $id');
    print('   Title: $title');
    print('   Body: $body');
    print('   Scheduled for: $scheduledDateTime');

    // Don't schedule notifications in the past
    if (scheduledDateTime.isBefore(DateTime.now())) {
      print(
        '⚠️ [NotificationService] Cannot schedule notification in the past: $scheduledDateTime',
      );
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'calendar_events',
          'Calendar Events',
          channelDescription: 'Notifications for upcoming calendar events',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF00CB41),
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convert to TZDateTime with detailed logging
    // Use UTC as fallback if local timezone is not initialized
    late final tz.Location location;
    try {
      location = tz.local;
    } catch (e) {
      print(
        '⚠️ [NotificationService] Local timezone not initialized, using UTC',
      );
      location = tz.UTC;
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDateTime, location);
    final now = tz.TZDateTime.now(location);

    print('🕐 [NotificationService] Timezone info:');
    print('   Local timezone: ${location.name}');
    print('   Input DateTime: $scheduledDateTime');
    print('   TZDateTime scheduled: $tzScheduledDate');
    print('   TZDateTime now: $now');
    final diffSeconds = tzScheduledDate.difference(now).inSeconds;
    print(
      '   Time until notification: $diffSeconds seconds (${(diffSeconds / 60).toStringAsFixed(1)} minutes)',
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: scheduledDateTime.toIso8601String(),
    );

    print(
      '✅ [NotificationService] Scheduled notification #$id for $scheduledDateTime',
    );
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
    print('🗑️ [NotificationService] Cancelled notification #$id');
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('🗑️ [NotificationService] Cancelled all notifications');
  }

  /// Get list of pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Show an immediate notification (for testing or instant alerts)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'calendar_events',
          'Calendar Events',
          channelDescription: 'Notifications for upcoming calendar events',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF00CB41),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );

    print('📬 [NotificationService] Showed immediate notification #$id');
  }

  /// Test notification - show immediately to verify notifications work
  Future<void> testNotificationNow() async {
    print('🧪 [NotificationService] Testing immediate notification...');
    await showNotification(
      id: 999999,
      title: 'Test Notification',
      body: 'If you see this, notifications are working! 🎉',
    );
    print('🧪 [NotificationService] Test notification sent!');
  }

  /// Test scheduled notification - schedule for 5 seconds from now
  Future<void> testScheduledNotification() async {
    print(
      '🧪 [NotificationService] Testing scheduled notification (5 seconds)...',
    );
    final testTime = DateTime.now().add(const Duration(seconds: 5));
    await scheduleNotification(
      id: 999998,
      title: 'Test Scheduled Notification',
      body: 'This notification should appear in 5 seconds',
      scheduledDateTime: testTime,
    );
    print(
      '🧪 [NotificationService] Scheduled test notification for 5 seconds from now',
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print(
      '📱 [NotificationService] Notification tapped: ${notificationResponse.id}',
    );
    // You can handle navigation or other actions here
    // For now, we'll just log it
  }

  /// Debug: Print all pending notifications
  Future<void> debugPrintPendingNotifications() async {
    final pending = await getPendingNotifications();
    print('📋 [NotificationService] ========================================');
    print('📋 [NotificationService] PENDING NOTIFICATIONS: ${pending.length}');

    if (pending.isEmpty) {
      print('📋 [NotificationService] No pending notifications');
    } else {
      for (var i = 0; i < pending.length; i++) {
        final notification = pending[i];
        print('📋 [NotificationService] #${i + 1}:');
        print('   ID: ${notification.id}');
        print('   Title: ${notification.title}');
        print('   Body: ${notification.body}');
        print('   Payload: ${notification.payload}');
      }
    }
    print('📋 [NotificationService] ========================================');
  }
}
