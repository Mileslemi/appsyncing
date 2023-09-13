import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class STextTheme {
  STextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
        fontSize: 25, color: darkColor, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(
        fontSize: 20, color: darkColor, fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.montserrat(
        fontSize: 17, color: darkColor, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.montserrat(
        fontSize: 15, color: darkColor, fontWeight: FontWeight.bold),
    bodyMedium: GoogleFonts.montserrat(
        fontSize: 13, color: darkColor, fontWeight: FontWeight.w500),
    bodySmall: GoogleFonts.montserrat(
        fontSize: 11, color: darkColor, fontWeight: FontWeight.w500),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
        fontSize: 25, color: lightColor, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(
        fontSize: 20, color: lightColor, fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.montserrat(
        fontSize: 17, color: lightColor, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.montserrat(
        fontSize: 15, color: lightColor, fontWeight: FontWeight.bold),
    bodyMedium: GoogleFonts.montserrat(
        fontSize: 13, color: lightColor, fontWeight: FontWeight.w500),
    bodySmall: GoogleFonts.montserrat(
        fontSize: 11, color: lightColor, fontWeight: FontWeight.w500),
  );
}
