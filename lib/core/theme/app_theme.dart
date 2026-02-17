import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carp_themes_package/carp_themes_package.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F2847);
  static const Color accentColor = Color(0xFF00D4E6);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color lightBackgroundColor = Color(0xFFF5F7FA);
  static const Color inverseTextColor = Color(0xFFFFFFFF);

  static const Color frameBorderColor = Color(0xFF242424);

  static const Color vasCogBackground = Color(0xFF90CB97);
  static const Color vasCogText = Color(0xFF414148);
  static const Color vasCogSurface = Color(0xFFE3F3E5);

  static const Color neuroCogBackground = Color(0xFFE58F8F);
  static const Color neuroCogText = Color(0xFF0A0A0A);
  static const Color neuroCogSurface = Color.fromARGB(255, 234, 227, 227);

  static const Color covidCogBackground = Color(0xFF81C5FE);
  static const Color covidCogText = Color(0xFF424242);
  static const Color covidCogSurface = Color(0xFFF0F7FF);

  static const Color sccCogBackground = Color(0xFF6DBAAB);
  static const Color sccCogText = Color(0xFF3B3B3B);
  static const Color sccCogSurface = Color(0xFFE1F0EE);

  static const Color darkBackground = Color(0xFF1F2937);
  static const Color darkSurface = Color(0xFF374151);

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2Xl = 48.0;

  static const double minTouchTarget = 44.0;
  static const double borderRadiusNone = 0.0;

  static Color _blendOn(Color base, Color overlay, double overlayOpacity) {
    return Color.alphaBlend(overlay.withValues(alpha: overlayOpacity), base);
  }

  static ThemeData _buildLightTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surfaceContainerHighest,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: background,
        surfaceContainerHighest: surfaceContainerHighest,
        onPrimary: inverseTextColor,
        onSecondary: primary,
        onSurface: primary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: background,
        foregroundColor: primary,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          side: BorderSide(color: frameBorderColor, width: 1),
        ),
        margin: const EdgeInsets.all(spacingMd),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: inverseTextColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          side: BorderSide(color: primary, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      iconTheme: IconThemeData(color: primary, size: 24),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: primary.withValues(alpha: 0.5),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHighest,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(borderRadiusNone)),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CarpColors(
          primary: primary,
          warningColor: Colors.orange[500],
          backgroundGray: surfaceContainerHighest,
          tabBarBackground: surfaceContainerHighest,
          white: background,
          grey50: const Color(0xFFFAFAFA),
          grey100: surfaceContainerHighest,
          grey200: const Color(0xFFE5E7EB),
          grey300: const Color(0xFFD1D5DB),
          grey400: const Color(0xFC515667),
          grey500: const Color(0xFC515667),
          grey600: const Color(0xFF4B5563),
          grey700: const Color(0xFF374151),
          grey800: const Color(0xFF1F2937),
          grey900: primary,
          grey950: const Color(0xFF030712),
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return _buildLightTheme(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surfaceContainerHighest: lightBackgroundColor,
    );
  }

  static ThemeData customizedLightTheme({
    required Color accent,
    required Color surfaceContainerHighest,
  }) {
    return _buildLightTheme(
      primary: primaryColor,
      secondary: accent,
      background: backgroundColor,
      surfaceContainerHighest: surfaceContainerHighest,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: primaryColor,
        surface: darkBackground,
        surfaceContainerHighest: darkSurface,
        onPrimary: primaryColor,
        onSecondary: inverseTextColor,
        onSurface: inverseTextColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: inverseTextColor,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: inverseTextColor,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: inverseTextColor,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inverseTextColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: darkBackground,
        foregroundColor: inverseTextColor,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          side: BorderSide(color: darkSurface, width: 1),
        ),
        margin: EdgeInsets.all(spacingMd),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          side: const BorderSide(color: accentColor, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      iconTheme: const IconThemeData(color: inverseTextColor, size: 24),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBackground,
        selectedItemColor: accentColor,
        unselectedItemColor: inverseTextColor.withValues(alpha: 0.5),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CarpColors(
          primary: accentColor,
          warningColor: Colors.orange[700],
          backgroundGray: darkSurface,
          tabBarBackground: darkSurface,
          white: darkBackground,
          grey50: const Color(0xFF030712),
          grey100: const Color(0xFF1F2937),
          grey200: const Color(0xFF374151),
          grey300: const Color(0xFF4B5563),
          grey400: const Color(0xFF6B7280),
          grey500: const Color(0xFF9CA3AF),
          grey600: const Color(0xFFD1D5DB),
          grey700: const Color(0xFFE5E7EB),
          grey800: lightBackgroundColor,
          grey900: const Color(0xFFFAFAFA),
          grey950: backgroundColor,
        ),
      ],
    );
  }
}
