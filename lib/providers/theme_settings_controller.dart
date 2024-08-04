import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeSettingsController {
  ThemeSettingsController(this._themeService);
  final ThemeService _themeService;

  late final ValueNotifier<ThemeMode> _themeMode =  ValueNotifier<ThemeMode>(_themeService.themeMode);
  ValueListenable<ThemeMode> get themeMode => _themeMode;

  // ThemeMode get themeMode => _themeService.themeMode;

  void onToggleTheme() {

    final currentThemeMode = themeMode.value;
    final newThemeMode = currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _themeMode.value = newThemeMode;

    _themeService.updateThemeMode(newThemeMode);
    // notifyListeners();
  }
}
