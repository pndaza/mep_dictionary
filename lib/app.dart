import 'package:flutter/material.dart';
import 'data/theme.dart';
import 'providers/theme_settings_controller.dart';
import 'package:provider/provider.dart';

import 'screen/home/home.dart';

class App extends StatelessWidget {
  const App({super.key, required this.themeSettingsController});
  final ThemeSettingsController themeSettingsController;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: themeSettingsController,
      child:
          ValueListenableBuilder(
            valueListenable: themeSettingsController.themeMode,
            builder: (_, themeMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          themeMode: themeMode,
          home: const Home(),
        );
      }),
    );
  }
}
