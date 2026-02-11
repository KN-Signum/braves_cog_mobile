import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carp_themes_package/carp_themes_package.dart';

// BRAVES-COG Styling Guide:
// Headings: Space Grotesk Bold
// Body Text: Inter Regular

/// Custom theme extension for Research Package colors
class RPColors extends ThemeExtension<RPColors> {
  final Color? primary;
  final Color? warningColor;
  final Color? backgroundGray;
  final Color? tabBarBackground;
  final Color? white;
  final Color? grey50;
  final Color? grey100;
  final Color? grey200;
  final Color? grey300;
  final Color? grey400;
  final Color? grey500;
  final Color? grey600;
  final Color? grey700;
  final Color? grey800;
  final Color? grey900;
  final Color? grey950;

  const RPColors({
    this.primary,
    this.warningColor,
    this.backgroundGray,
    this.tabBarBackground,
    this.white,
    this.grey50,
    this.grey100,
    this.grey200,
    this.grey300,
    this.grey400,
    this.grey500,
    this.grey600,
    this.grey700,
    this.grey800,
    this.grey900,
    this.grey950,
  });

  @override
  RPColors copyWith({
    Color? primary,
    Color? warningColor,
    Color? backgroundGray,
    Color? tabBarBackground,
    Color? white,
    Color? grey50,
    Color? grey100,
    Color? grey200,
    Color? grey300,
    Color? grey400,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
    Color? grey950,
  }) {
    return RPColors(
      primary: primary ?? this.primary,
      warningColor: warningColor ?? this.warningColor,
      backgroundGray: backgroundGray ?? this.backgroundGray,
      tabBarBackground: tabBarBackground ?? this.tabBarBackground,
      white: white ?? this.white,
      grey50: grey50 ?? this.grey50,
      grey100: grey100 ?? this.grey100,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
      grey950: grey950 ?? this.grey950,
    );
  }

  @override
  RPColors lerp(ThemeExtension<RPColors>? other, double t) {
    if (other is! RPColors) {
      return this;
    }
    return RPColors(
      primary: Color.lerp(primary, other.primary, t),
      warningColor: Color.lerp(warningColor, other.warningColor, t),
      backgroundGray: Color.lerp(backgroundGray, other.backgroundGray, t),
      tabBarBackground: Color.lerp(tabBarBackground, other.tabBarBackground, t),
      white: Color.lerp(white, other.white, t),
      grey50: Color.lerp(grey50, other.grey50, t),
      grey100: Color.lerp(grey100, other.grey100, t),
      grey200: Color.lerp(grey200, other.grey200, t),
      grey300: Color.lerp(grey300, other.grey300, t),
      grey400: Color.lerp(grey400, other.grey400, t),
      grey500: Color.lerp(grey500, other.grey500, t),
      grey600: Color.lerp(grey600, other.grey600, t),
      grey700: Color.lerp(grey700, other.grey700, t),
      grey800: Color.lerp(grey800, other.grey800, t),
      grey900: Color.lerp(grey900, other.grey900, t),
      grey950: Color.lerp(grey950, other.grey950, t),
    );
  }
}

/// BRAVES-COG Styling Guide v1.0
/// Based on: BRAVES-COG STYLING GUIDE (1).pdf
class AppTheme {
  // PALETA KOLORÓW - ze styling guide

  /// Primary - Navy Blue #0F2847
  static const Color primaryColor = Color(0xFF0F2847);

  /// Accent - Cyan #00D4E6
  static const Color accentColor = Color(0xFF00D4E6);

  /// Background - White #FFFFFF
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Light Background #F5F7FA
  static const Color lightBackgroundColor = Color(0xFFF5F7FA);

  /// Inverse Text - White (for text on dark backgrounds)
  static const Color inverseTextColor = Color(0xFFFFFFFF);

  // SPACING SYSTEM - wielokrotności 4px
  static const double spacingXs = 4.0; // xs
  static const double spacingSm = 8.0; // sm
  static const double spacingMd = 16.0; // md (standardowy)
  static const double spacingLg = 24.0; // lg
  static const double spacingXl = 32.0; // xl
  static const double spacing2Xl = 48.0; // 2xl (główne sekcje)

  // ACCESSIBILITY - minimum touch targets
  static const double minTouchTarget = 44.0;

  // BORDER RADIUS - tylko okręgi i proste linie
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Primary colors
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

      // TYPOGRAFIA - Space Grotesk (headings) & Inter (body)
      // Zgodnie z BRAVES-COG Styling Guide
      textTheme: TextTheme(
        // Headings - Space Grotesk Bold
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: -0.3,
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
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),

        // Body Text - Inter Regular (minimum 16px)
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16, // Minimum 16px dla body text
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryColor,
          height: 1.4,
        ),

        // Labels - Inter
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
      ),

      // AppBar
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
        iconTheme: const IconThemeData(color: primaryColor, size: 24),
      ),

      // Cards - głębia przez kontrast, nie cienie
      cardTheme: CardThemeData(
        elevation: 0, // Bez cieni - używamy kontrastu kolorów
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          side: BorderSide(color: lightBackgroundColor, width: 1),
        ),
        margin: const EdgeInsets.all(spacingMd),
      ),

      // Buttons - minimum 44px wysokości (accessibility)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: inverseTextColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          elevation: 0, // Bez cieni
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingSm,
          ),
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: lightBackgroundColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 16, color: primaryColor),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: primaryColor.withValues(alpha: 0.5),
        ),
      ),

      // Bottom Navigation
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

      // Icon Theme - 2px outline (zgodnie z wytycznymi)
      iconTheme: const IconThemeData(color: primaryColor, size: 24),

      // Divider
      dividerTheme: DividerThemeData(
        color: lightBackgroundColor,
        thickness: 1,
        space: spacingMd,
      ),

      // Research Package Colors
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

  // Dark theme - opcjonalny, bazujący na tych samych zasadach
  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF1F2937);
    const darkSurface = Color(0xFF374151);

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
        // Headings - Space Grotesk Bold
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: inverseTextColor,
          letterSpacing: -0.3,
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
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inverseTextColor,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: inverseTextColor,
        ),

        // Body Text - Inter Regular
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
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: inverseTextColor,
          height: 1.4,
        ),

        // Labels - Inter
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inverseTextColor,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: inverseTextColor,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
        iconTheme: const IconThemeData(color: inverseTextColor, size: 24),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          side: BorderSide(color: darkSurface, width: 1),
        ),
        margin: const EdgeInsets.all(spacingMd),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingSm,
          ),
          side: const BorderSide(color: accentColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: darkSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 16, color: inverseTextColor),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: inverseTextColor.withValues(alpha: 0.5),
        ),
      ),

      // Bottom Navigation
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

      // Icon Theme
      iconTheme: const IconThemeData(color: inverseTextColor, size: 24),

      // Divider
      dividerTheme: DividerThemeData(
        color: darkSurface,
        thickness: 1,
        space: spacingMd,
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
