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

import 'package:flutter_localizations/flutter_localizations.dart';

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

  /// Zwraca komplet kolorów dla danej grupy:
  /// ($1) kolor AKCENTU (kolor grupy),
  /// ($2) jasne powierzchnie / ramki (karty, pola).
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
