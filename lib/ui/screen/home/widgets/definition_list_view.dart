import 'package:flutter/material.dart';
import 'package:mep_dictionary/business_logic/view_models/definition_list_view_model.dart';

import 'definition_list_tile.dart';

class DefinitionListView extends StatelessWidget {
  final List<DefinitionViewModel> definitions;
  final textToHighlight;

  DefinitionListView({this.definitions, this.textToHighlight = ''});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: definitions.length,
      itemBuilder: (context, index) {
        return DefinitionListTile(
            definitions[index]);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
    );
  }
}
