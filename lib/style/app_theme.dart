import 'package:flutmdb/style/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData defaultAppTheme() {
    return ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kColorPrimary,
          secondary: kColorAccent,
          surface: kColorSurface,
        ));
  }
}
