import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/data/theme.dart';
import 'package:mep_dictionary/providers/theme_settings_controller.dart';

import 'screen/home/home.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ref.watch(themeSettingsProvider),
      home: const Home(),
    );
  }
}
