import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class SElevatedButtonTheme {
  SElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(
        vertical: verticalBtnPadding, horizontal: horizontalBtnPadding),
    backgroundColor: lightAccentColor,
    foregroundColor: lightColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    side: const BorderSide(color: lightAccentColor),
  ));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(
        vertical: verticalBtnPadding, horizontal: horizontalBtnPadding),
    backgroundColor: darkAccentColor,
    foregroundColor: darkColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    side: const BorderSide(color: darkAccentColor),
  ));
}
