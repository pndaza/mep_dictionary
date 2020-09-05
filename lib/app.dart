import 'package:flutter/material.dart';
import 'package:mep_dictionary/data/theme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'business_logic/view_models/definition_list_view_model.dart';
import 'ui/screen/home/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<AppTheme> themes = MyTheme.fetchAll();
    
    return ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        defaultThemeId: themes.first.id,
        themes: themes,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
            home: ChangeNotifierProvider(
              create: (_) => DefinitionListViewModel(),
              child: ThemeConsumer(child: Home()))));
  }
}
