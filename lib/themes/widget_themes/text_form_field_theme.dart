import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightTextFormFieldTheme =
      const InputDecorationTheme(
    prefixIconColor: lightAccentColor,
    suffixIconColor: lightAccentColor,
    border: OutlineInputBorder(borderSide: BorderSide(color: lightAccentColor)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: lightAccentColor)),
  );

  static InputDecorationTheme darkTextFormFieldTheme =
      const InputDecorationTheme(
    prefixIconColor: darkAccentColor,
    suffixIconColor: darkAccentColor,
    border: OutlineInputBorder(borderSide: BorderSide(color: darkAccentColor)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: darkAccentColor)),
  );
}
