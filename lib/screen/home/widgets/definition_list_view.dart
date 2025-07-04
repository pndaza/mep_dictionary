import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import '../../../providers/home_controller.dart';
import 'favourite_controller.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../model/definition.dart';
import 'definition_list_tile.dart';

class DefinitionListView extends StatefulWidget {
  final List<Definition> definitions;
  const DefinitionListView({super.key, required this.definitions});

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
    final homeController = context.read<HomeViewController>();
    final favouritesController = context.read<FavouritesController>();
    final filterdWord = homeController.filterWord;
    final childCount = widget.definitions.length;
    final sliverDelegate = SliverChildBuilderDelegate(
      (context, index) => DefinitionListTile(
        key: Key('${widget.definitions[index].id}'),
        definition: widget.definitions[index],
        isFavourite: isFavourite(widget.definitions[index].id),
        filterWord: filterdWord,
        onAddtoFavourite: () {
          favouritesController.addToFavourite(widget.definitions[index].id);
          homeController.onFavouriteListChange();
        },
        onRemoveFromFavourite: () {
          favouritesController
              .removeFromFavourite(widget.definitions[index].id);
          homeController.onFavouriteListChange();
        },
      ),
      childCount: childCount,
    );

    return ContextMenuOverlay(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            interactive: true,
            crossAxisMargin: 4,
            radius: const Radius.circular(8.0),
            thickness: WidgetStateProperty.resolveWith<double>(
              (states) {
                if (states.contains(WidgetState.dragged) ||
                    states.contains(WidgetState.focused) ||
                    states.contains(WidgetState.hovered)) {
                  return 24;
                }
                return 12.0;
              },
            ),
          ),
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
        ),
      ),
    );
  }

  bool isFavourite(int id) {
    final favouritesController = context.read<FavouritesController>();
    return favouritesController.isInFavourite(id);
  }
}
