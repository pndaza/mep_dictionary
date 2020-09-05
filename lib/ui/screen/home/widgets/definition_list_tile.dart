import 'package:flutter/material.dart';
import 'package:mep_dictionary/business_logic/view_models/definition_list_view_model.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:theme_provider/theme_provider.dart';

class DefinitionListTile extends StatelessWidget {
  final DefinitionViewModel _definition;

  DefinitionListTile(this._definition);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        fontSize: 18.0,
        color: ThemeProvider.themeOf(context).data.textTheme.bodyText2.color);
    TextStyle textStyleForHighlight = TextStyle(
        fontSize: 18.0, color: ThemeProvider.themeOf(context).data.accentColor);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubstringHighlight(
            text: _definition.myanmar,
            term: _definition.textToHighlight,
            textStyle: textStyle,
            textStyleHighlight: textStyleForHighlight,
          ),
          SubstringHighlight(
            text: _definition.english,
            term: _definition.textToHighlight,
            textStyle: textStyle,
            textStyleHighlight: textStyleForHighlight,
          ),SubstringHighlight(
            text: _definition.pali,
            term: _definition.textToHighlight,
            textStyle: textStyle,
            textStyleHighlight: textStyleForHighlight,
          ),
        ],
      ),
    );
  }
}
