import 'package:flutter/material.dart';
import 'package:mep_dictionary/screen/home/favourite_controller.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/definition.dart';
import '../home_controller.dart';

class DefinitionListTile extends StatefulWidget {
  final Definition definition;

  DefinitionListTile({required this.definition});

  @override
  State<DefinitionListTile> createState() => _DefinitionListTileState();
}

class _DefinitionListTileState extends State<DefinitionListTile> {
  late bool isInFavourites;
  late String textToHighlight;
  // style for normal text

  @override
  void initState() {
    textToHighlight =
        context.read(homeControllerProvider.notifier).textToHighlight;
    final favourites = context.read(favouritesProvider);
    isInFavourites = favourites.contains(widget.definition.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build list tile- id : ${widget.definition.id}');
    print('is in favourites: $isInFavourites');
    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18);
    final textStyleHighlight = TextStyle(
        fontSize: 18.0,
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
                      text: widget.definition.myanmar,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                    SubstringHighlight(
                      text: widget.definition.english,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                    SubstringHighlight(
                      text: widget.definition.pali,
                      term: textToHighlight,
                      textStyle: textStyle,
                      textStyleHighlight: textStyleHighlight,
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    context
                        .read(favouritesProvider.notifier)
                        .onFavouriteChanged(widget.definition.id);
                    setState(() => isInFavourites = !isInFavourites);
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
