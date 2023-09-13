import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SBottomNavBarTheme {
  SBottomNavBarTheme._();

  static const lightBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: backGroundColor,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    unselectedItemColor: slightlyDarkColor,
    selectedItemColor: lightAccentColor,
    selectedIconTheme: IconThemeData(size: 18),
    unselectedIconTheme: IconThemeData(size: 16),
    selectedLabelStyle: TextStyle(fontSize: 11),
    unselectedLabelStyle: TextStyle(fontSize: 9),
    elevation: 1,
  );

  static const darkBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: darkModeBackgroundColor,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    selectedItemColor: darkAccentColor,
    selectedIconTheme: IconThemeData(size: 18),
    unselectedIconTheme: IconThemeData(size: 16),
    selectedLabelStyle: TextStyle(fontSize: 11),
    unselectedLabelStyle: TextStyle(fontSize: 9),
    elevation: 1,
  );
}
