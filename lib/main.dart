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

Future main() async {
  await EnvConfig.init();
  final prefs = await SharedPreferences.getInstance();
  CognitionPackage.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Braves Cog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      supportedLocales: const [
        Locale('en'),
        Locale('da'),
        Locale('fr'),
        Locale('pt'),
      ],
      localizationsDelegates: [
        RPLocalizations.delegate,
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
