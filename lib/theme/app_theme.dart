import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Slate & Rich Gold Archetype Colors
  static const Color background = Color(0xFF0C0A09);      // Stone-950 Carbon
  static const Color surface = Color(0xFF1C1917);         // Stone-900 Card
  static const Color surfaceLighter = Color(0xFF292524);  // Stone-800
  static const Color surfaceElevated = Color(0xFF171412);
  
  // Accents
  static const Color gold = Color(0xFFEAB308);            // Amber/Gold #EAB308
  static const Color goldLight = Color(0xFFFDE047);
  static const Color goldDark = Color(0xFFCA8A04);
  static const Color goldBorder = Color(0x33D5A549);      // #D5A549 with 20% opacity
  
  static const Color emerald = Color(0xFF059669);         // Emerald #059669
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color rose = Color(0xFFE11D48);            // Rose for delete/cancellation
  static const Color textLight = Color(0xFFF5F5F4);       // Stone-100
  static const Color textMuted = Color(0xFFA8A29E);       // Stone-400
  static const Color textDim = Color(0xFF78716C);         // Stone-500

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: emerald,
        surface: surface,
        background: background,
        error: rose,
        onPrimary: Color(0xFF0C0A09),
        onSurface: textLight,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.tajawal(color: textLight, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.tajawal(color: textLight, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.tajawal(color: gold, fontWeight: FontWeight.w900),
        titleMedium: GoogleFonts.tajawal(color: textLight, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.cairo(color: textLight),
        bodyMedium: GoogleFonts.cairo(color: textMuted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141210),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: gold),
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: goldBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF0C0A09),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF141210),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF292524)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF292524)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textDim, fontSize: 12),
      ),
    );
  }
}
