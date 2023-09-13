import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SAppBarTheme {
  SAppBarTheme._();

  static const AppBarTheme lightModeTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: backGroundColor,
    elevation: 0.2,
  );

  static const AppBarTheme darkModeTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: darkModeBackgroundColor,
    elevation: 0.2,
  );
}
