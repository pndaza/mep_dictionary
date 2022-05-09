import 'package:flutter/material.dart';

import '../../../model/definition.dart';
import 'definition_list_tile.dart';

class DefinitionListView extends StatelessWidget {
  final List<Definition> definitions;
  const DefinitionListView({Key? key, required this.definitions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: definitions.length,
      itemBuilder: (context, index) {
        return DefinitionListTile(definition: definitions[index]);
      },
    );
  }
}
