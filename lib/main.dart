import 'dart:io';

import 'package:flutter/material.dart';
import 'providers/theme_settings_controller.dart';
import 'services/theme_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'services/prefs.dart';

void main() async {
  //
  //
  if (Platform.isWindows || Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.
  await Prefs.init();
  ThemeService themeService = ThemeService();
  ThemeSettingsController themeSettingsController =
      ThemeSettingsController(themeService);
  runApp(App(themeSettingsController: themeSettingsController));
}
