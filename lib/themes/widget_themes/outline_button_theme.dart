import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class SOutlineButtonTheme {
  SOutlineButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(
        vertical: verticalBtnPadding, horizontal: horizontalBtnPadding),
    foregroundColor: darkColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    side: const BorderSide(color: darkColor),
  ));

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(
        vertical: verticalBtnPadding, horizontal: horizontalBtnPadding),
    foregroundColor: lightColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    side: const BorderSide(color: lightColor),
  ));
}
