import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/core/providers/theme_provider.dart';
import 'package:braves_cog/features/main/main_screen_new.dart';
import 'package:research_package/research_package.dart';
import 'package:cognition_package/cognition_package.dart';
import 'package:braves_cog/core/config/env_config.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:braves_cog/core/services/notification_service.dart';
import 'package:braves_cog/core/providers/notification_service_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:flutter_localizations/flutter_localizations.dart';

/// Initialize timezone database for notification scheduling
Future<void> _initializeTimezone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
}

Future<NotificationService> _initializeNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final notificationService = NotificationService(
    flutterLocalNotificationsPlugin,
  );

  final initialized = await notificationService.initialize();

  if (initialized) {
    print('✅ [Main] Notifications initialized successfully');
    // Request permissions (will show dialog on iOS and Android 13+)
    await notificationService.requestPermissions();

    // Check final permission status
    final enabled = await notificationService.areNotificationsEnabled();
    if (!enabled) {
      print('⚠️ [Main] WARNING: User did not grant notification permissions!');
      print(
        '   Notifications will NOT work until permissions are granted in system settings',
      );
    } else {
      // Test immediate notification to verify it works
      // print('🧪 [Main] Testing notifications...');
      // await notificationService.testNotificationNow();

      // Test scheduled notification (5 seconds from now)
      // print('🧪 [Main] Scheduling test notification for 5 seconds from now...');
      // await notificationService.testScheduledNotification();

      // Show what's actually scheduled
      await notificationService.debugPrintPendingNotifications();
    }
  } else {
    print('⚠️ [Main] Failed to initialize notifications');
  }

  return notificationService;
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: 'https://oozravmirgabrjirmptd.supabase.co',
    anonKey: 'sb_publishable_ffjOxjbGOUZ1tnIqH3qJ7Q_PRR_VXdr',
  );

  await EnvConfig.init();
  await _initializeTimezone();

  // Initialize notifications
  final notificationService = await _initializeNotifications();

  final prefs = await SharedPreferences.getInstance();
  CognitionPackage.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  (Color accent, Color surface)? _customPaletteFor(UserType type) {
    return switch (type) {
      UserType.vasCog => (AppTheme.vasCogBackground, AppTheme.vasCogSurface),
      UserType.neuroCog => (
        AppTheme.neuroCogBackground,
        AppTheme.neuroCogSurface,
      ),
      UserType.covidCog => (
        AppTheme.covidCogBackground,
        AppTheme.covidCogSurface,
      ),
      UserType.sccCog => (AppTheme.sccCogBackground, AppTheme.sccCogSurface),
      UserType.normalCog => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final userType = ref.watch(profileProvider).profile.type;
    final groupVariant = ref.watch(groupThemeVariantProvider);

    debugPrint('*** CURRENT USER TYPE: $userType, variant: $groupVariant');

    final palette = _customPaletteFor(userType);
    final ThemeData lightTheme =
        (palette != null && groupVariant == GroupThemeVariant.customized)
        ? AppTheme.customizedLightTheme(
            accent: palette.$1,
            surfaceContainerHighest: palette.$2,
          )
        : AppTheme.lightTheme;

    // Zgodnie z wymaganiem: grupy (poza NormalCog) mają tylko 2 warianty
    // w motywie jasnym (Standardowy/Dostosowany). Nie pokazujemy trybu ciemnego.
    final effectiveThemeMode = (userType == UserType.normalCog)
        ? themeMode
        : ThemeMode.light;

    return MaterialApp(
      title: 'Braves Cog',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: effectiveThemeMode,
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
        Locale('da'),
        Locale('fr'),
        Locale('pt'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        RPLocalizationsDelegate(loaders: []),
        CPLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode) {
            return supportedLocale;
          }
        }
        // if the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: const MainScreenNew(),
    );
  }
}
