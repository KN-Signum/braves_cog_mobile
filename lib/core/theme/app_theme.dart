import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carp_themes_package/carp_themes_package.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F2847);
  static const Color accentColor = Color(0xFF00D4E6);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color lightBackgroundColor = Color(0xFFF5F7FA);
  static const Color inverseTextColor = Color(0xFFFFFFFF);

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

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: backgroundColor,
        surfaceContainerHighest: lightBackgroundColor,
        onPrimary: inverseTextColor,
        onSecondary: primaryColor,
        onSurface: primaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusNone)),
          side: BorderSide(color: lightBackgroundColor, width: 1),
        ),
        margin: EdgeInsets.all(spacingMd),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: inverseTextColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          side: const BorderSide(color: primaryColor, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      iconTheme: const IconThemeData(color: primaryColor, size: 24),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: accentColor,
        unselectedItemColor: primaryColor.withValues(alpha: 0.5),
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
        fillColor: lightBackgroundColor,
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
          primary: primaryColor,
          warningColor: Colors.orange[500],
          backgroundGray: lightBackgroundColor,
          tabBarBackground: lightBackgroundColor,
          white: backgroundColor,
          grey50: const Color(0xFFFAFAFA),
          grey100: lightBackgroundColor,
          grey200: const Color(0xFFE5E7EB),
          grey300: const Color(0xFFD1D5DB),
          grey400: const Color(0xFF9CA3AF),
          grey500: const Color(0xFF6B7280),
          grey600: const Color(0xFF4B5563),
          grey700: const Color(0xFF374151),
          grey800: const Color(0xFF1F2937),
          grey900: primaryColor,
          grey950: const Color(0xFF030712),
        ),
      ],
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
