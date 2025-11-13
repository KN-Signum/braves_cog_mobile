import 'package:flutter/material.dart';
import 'package:research_package/research_package.dart';

class AppTheme {
  // Primary color scheme
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color accentColor = Color(0xFFFF5722);

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      extensions: <ThemeExtension<dynamic>>[
        RPColors(
          primary: primaryColor,
          warningColor: Colors.orange[500],
          backgroundGray: const Color(0xfff2f2f7),
          tabBarBackground: const Color.fromARGB(255, 227, 227, 228),
          white: const Color(0xffFFFFFF),
          grey50: const Color(0xffFCFCFF),
          grey100: const Color(0xffF2F2F7),
          grey200: const Color(0xffE5E5EA),
          grey300: const Color(0xffD1D1D6),
          grey400: const Color(0xffBABABA),
          grey500: const Color(0xff9B9B9B),
          grey600: const Color(0xff848484),
          grey700: const Color(0xff3A3A3C),
          grey800: const Color(0xff2C2C2E),
          grey900: const Color(0xff1C1C1E),
          grey950: const Color(0xff0E0E0E),
        ),
      ],
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      extensions: <ThemeExtension<dynamic>>[
        RPColors(
          primary: primaryColor,
          warningColor: Colors.orange[700],
          backgroundGray: const Color(0xff1C1C1E),
          tabBarBackground: const Color(0xff2C2C2E),
          white: const Color(0xff1C1C1E),
          grey50: const Color(0xff0E0E0E),
          grey100: const Color(0xff1C1C1E),
          grey200: const Color(0xff2C2C2E),
          grey300: const Color(0xff3A3A3C),
          grey400: const Color(0xff848484),
          grey500: const Color(0xff9B9B9B),
          grey600: const Color(0xffBABABA),
          grey700: const Color(0xffD1D1D6),
          grey800: const Color(0xffE5E5EA),
          grey900: const Color(0xffF2F2F7),
          grey950: const Color(0xffFCFCFF),
        ),
      ],
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}
