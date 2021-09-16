import 'package:flutter/material.dart';

import 'package:mep_dictionary/services/prefs.dart';

class ThemeService {
  ThemeMode get themeMode =>
      Prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void updateThemeMode(ThemeMode value) {
    Prefs.isDarkMode = value == ThemeMode.dark ? true : false;
  }
}
