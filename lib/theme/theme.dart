import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizcreator/utils/constant/colors.dart';

class AppTheme {
  // Color constants
 
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsApp.backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: ColorsApp.primaryText,
      secondary: ColorsApp.secondaryText,
      error: ColorsApp.incorrectAnswer,
      surface: ColorsApp.surfaceColor,    
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.openSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ColorsApp.primaryText,
      ),
      displayMedium: GoogleFonts.openSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ColorsApp.primaryText,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 20,
        color: ColorsApp.primaryText,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 18,
        color: ColorsApp.primaryText,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 16,
        color: ColorsApp.secondaryText,
        height: 1.6,
      ),
    ),

    // Button Theme
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.buttonColor,
        foregroundColor: ColorsApp.primaryText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorsApp.primaryText,
      linearTrackColor: ColorsApp.progressBarBackground,
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: ColorsApp.buttonColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: ColorsApp.primaryText,
      size: 24,
    ),
  );


}