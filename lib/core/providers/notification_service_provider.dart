import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:braves_cog/core/services/notification_service.dart';

/// Provides the app-wide [NotificationService].
///
/// Overridden in `main.dart` with the fully-initialized instance so that
/// notification permissions and platform setup only happen once at startup.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  // Default: uninitialized plugin. Fine for widget tests and before main.dart
  // override kicks in. Platform methods will be no-ops until initialized.
  return NotificationService(FlutterLocalNotificationsPlugin());
});
