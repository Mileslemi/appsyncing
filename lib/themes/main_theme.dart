import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'widget_themes/app_bar_theme.dart';
import 'widget_themes/bottom_nav_bar_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/icon_theme.dart';
import 'widget_themes/list_style_theme.dart';
import 'widget_themes/outline_button_theme.dart';
import 'widget_themes/text_form_field_theme.dart';
import 'widget_themes/text_theme.dart';

class MainTheme {
  MainTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: backGroundColor,
    appBarTheme: SAppBarTheme.lightModeTheme,
    bottomNavigationBarTheme: SBottomNavBarTheme.lightBottomNavigationBarTheme,
    textTheme: STextTheme.lightTextTheme,
    inputDecorationTheme: STextFormFieldTheme.lightTextFormFieldTheme,
    elevatedButtonTheme: SElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: SOutlineButtonTheme.lightOutlinedButtonTheme,
    iconTheme: SIconTheme.lightIconTheme,
    listTileTheme: SListTileTheme.lightListTileTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.yellow,
    appBarTheme: SAppBarTheme.darkModeTheme,
    bottomNavigationBarTheme: SBottomNavBarTheme.darkBottomNavigationBarTheme,
    textTheme: STextTheme.darkTextTheme,
    inputDecorationTheme: STextFormFieldTheme.darkTextFormFieldTheme,
    elevatedButtonTheme: SElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: SOutlineButtonTheme.darkOutlinedButtonTheme,
    iconTheme: SIconTheme.darkIconTheme,
    listTileTheme: SListTileTheme.darkListTileTheme,
  );
}
