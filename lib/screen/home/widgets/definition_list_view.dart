import 'package:flutter/material.dart';

import '../../../model/definition.dart';
import 'definition_list_tile.dart';

class DefinitionListView extends StatefulWidget {
  final List<Definition> definitions;
  const DefinitionListView({Key? key, required this.definitions})
      : super(key: key);

  @override
  State<DefinitionListView> createState() => _DefinitionListViewState();
}

class _DefinitionListViewState extends State<DefinitionListView> {
  late final ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        // controller: controller,
        itemCount: widget.definitions.length,
        itemBuilder: (context, index) {
          return DefinitionListTile(definition: widget.definitions[index]);
        },
      ),
    );
  }
}
