import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        primaryColor: ColorPallete.primary,
        colorScheme: const ColorScheme.light(
          primary: ColorPallete.primary,
        ),
        useMaterial3: true,

        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          focusColor: Colors.white,
          isDense: true,
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: ColorPallete.disabled),
          ),
        ));
  }
}
