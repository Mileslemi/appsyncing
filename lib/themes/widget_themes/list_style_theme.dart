import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SListTileTheme {
  SListTileTheme._();

  static const lightListTileTheme = ListTileThemeData(
    iconColor: lightAccentColor,
    dense: true,
  );

  static const darkListTileTheme = ListTileThemeData(
    iconColor: darkAccentColor,
    dense: true,
  );
}
