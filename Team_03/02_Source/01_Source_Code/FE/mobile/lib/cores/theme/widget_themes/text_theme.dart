import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/cores/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: NeutralColors.dark500,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: NeutralColors.dark500,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: HighlightColors.highlight500,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: NeutralColors.light100,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: NeutralColors.light100,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: NeutralColors.light100,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.poppins(
      color: NeutralColors.dark400,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: GoogleFonts.poppins(
      color: NeutralColors.light200,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );
}
