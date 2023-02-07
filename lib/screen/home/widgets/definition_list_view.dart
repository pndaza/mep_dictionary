import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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
    final childCount = widget.definitions.length;
    final sliverDelegate = SliverChildBuilderDelegate(
      (context, index) =>
          DefinitionListTile(definition: widget.definitions[index]),
      childCount: childCount,
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
      child: CustomScrollView(
        slivers: [
          SuperSliverList(delegate: sliverDelegate),
        ],
      ),
    );
  }
}
