import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/providers/font_size_settings_controller.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../../providers/favourite_controller.dart';
import '../../../model/definition.dart';
import '../../../providers/home_controller.dart';

class DefinitionListTile extends ConsumerWidget {
  final Definition definition;

  DefinitionListTile({required this.definition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInFavourites = ref.watch(favouritesProvider.select<bool>(
        (List<int> favourites) => favourites.contains(definition.id)));
    // get hightlighted text
    final fontSize = ref.watch(fontSizeSettingsProvider);
    final textToHighlight =
        ref.read(homeViewControllerProvider.notifier).textToHighlight;
    // text style for normal text
    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: fontSize);
    // filterd word will be highlight
    // text sytle for highlight
    final textStyleHighlight = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Card(
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubstringHighlight(
                      text: definition.myanmar,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                    SubstringHighlight(
                      text: definition.english,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                    SubstringHighlight(
                      text: definition.pali,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    final controller = ref.read(favouritesProvider.notifier);
                    isInFavourites
                        ? controller.removeFromFavourite(definition.id)
                        : controller.addToFavourite(definition.id);
                  },
                  icon: isInFavourites
                      ? Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        )
                      : Icon(Icons.favorite_outline))
            ],
          ),
        ),
      ),
    );
  }
}
