import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/services/theme_service.dart';

final themeSettingsProvider =
    StateNotifierProvider<ThemeSettingsController, ThemeMode>(
        (ref) => ThemeSettingsController(ThemeService()));

class ThemeSettingsController extends StateNotifier<ThemeMode> {
  ThemeSettingsController(this.themeService) : super(themeService.themeMode);

  final ThemeService themeService;
  ThemeMode get themeMode => themeService.themeMode;

  void onToggleTheme() {
    final newThemeMode =
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newThemeMode;
    themeService.updateThemeMode(newThemeMode);
  }
}
