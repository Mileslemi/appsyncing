import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class SIconTheme {
  SIconTheme._();

  static IconThemeData lightIconTheme = const IconThemeData(
    color: lightAccentColor,
    size: 20,
  );

  static IconThemeData darkIconTheme = const IconThemeData(
    color: darkAccentColor,
    size: 20,
  );
}
