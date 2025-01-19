import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color constants
  static const Color backgroundColor = Color(0xFF121212);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF8E8E8E);
  static const Color correctAnswer = Color(0xFF4CAF50);
  static const Color incorrectAnswer = Color(0xFFF44336);
  static const Color buttonColor = Color(0xFF373737);
  static const Color progressBarBackground = Color(0xFF555555);
  static const Color surfaceColor = Color(0xFF1E1E1E);  // Added surface color
  static const Color borderColor = Color(0xFF2C2C2C);   // Added border color

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark(
      background: backgroundColor,
      primary: primaryText,
      secondary: secondaryText,
      error: incorrectAnswer,
      surface: surfaceColor,    // Updated to use surfaceColor
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.openSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      displayMedium: GoogleFonts.openSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 20,
        color: primaryText,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 18,
        color: primaryText,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 16,
        color: secondaryText,
        height: 1.6,
      ),
    ),

    // Button Theme
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: primaryText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryText,
      linearTrackColor: progressBarBackground,
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: buttonColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: primaryText,
      size: 24,
    ),
  );


}