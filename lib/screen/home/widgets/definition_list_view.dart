import 'package:context_menus/context_menus.dart';
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
  void didUpdateWidget(covariant DefinitionListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.definitions.length != oldWidget.definitions.length) {
      Future.delayed(
        const Duration(milliseconds: 50),
        (() => controller.jumpTo(0.0)),
      );
    }
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

    return ContextMenuOverlay(
      child: Scrollbar(
        controller: controller,
        interactive: true,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SuperSliverList(delegate: sliverDelegate),
          ],
        ),
      ),
    );
  }
}
