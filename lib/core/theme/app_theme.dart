import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryBurgundy = Color(0xFF850F1D);
  static const Color primaryBurgundyDark = Color(0xFF630A15);
  static const Color accentAmber = Color(0xFFD5A549);
  static const Color accentAmberLight = Color(0xFFF0CB78);
  static const Color backgroundLight = Color(0xFFFAF7F0);
  static const Color surfaceLight = Colors.white;
  static const Color backgroundDark = Color(0xFF12100C);
  static const Color surfaceDark = Color(0xFF1E1914);
  static const Color cardDark = Color(0xFF28221B);
  static const Color textLightPrimary = Color(0xFF231E19);
  static const Color textLightSecondary = Color(0xFF6B635B);
  static const Color textDarkPrimary = Color(0xFFFAF1D6);
  static const Color textDarkSecondary = Color(0xFFAD9C88);
  static const Color greenGain = Color(0xFF10B981);
  static const Color redLoss = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBurgundy,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBurgundy,
        secondary: AppColors.accentAmber,
        surface: AppColors.surfaceLight,
      ),
      textTheme: GoogleFonts.tajawalTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(fontWeight: FontWeight.w900, color: AppColors.textLightPrimary),
        headlineMedium: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: AppColors.textLightPrimary),
        titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.textLightPrimary),
        bodyLarge: GoogleFonts.tajawal(color: AppColors.textLightPrimary),
        bodyMedium: GoogleFonts.tajawal(color: AppColors.textLightSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryBurgundy),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentAmber,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentAmber,
        secondary: AppColors.primaryBurgundy,
        surface: AppColors.surfaceDark,
      ),
      textTheme: GoogleFonts.tajawalTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(fontWeight: FontWeight.w900, color: AppColors.textDarkPrimary),
        headlineMedium: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: AppColors.textDarkPrimary),
        titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary),
        bodyLarge: GoogleFonts.tajawal(color: AppColors.textDarkPrimary),
        bodyMedium: GoogleFonts.tajawal(color: AppColors.textDarkSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.accentAmber),
      ),
    );
  }
}
