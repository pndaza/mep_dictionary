import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/data/constants.dart';
import 'package:mep_dictionary/providers/font_size_settings_controller.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/definition.dart';
import '../../../providers/favourite_controller.dart';
import '../../../providers/home_controller.dart';

class DefinitionListTile extends ConsumerWidget {
  const DefinitionListTile({Key? key, required this.definition})
      : super(key: key);
  final Definition definition;

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

    return GestureDetector(
      onTap: () {},
      onDoubleTap: (() async {
        final entryParmater =
            '${definition.myanmar}\n${definition.english}\n${definition.pali}\npage-${definition.pageNumber}';
        final url = Uri.parse(kReportUrl + entryParmater);
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        } else {
          MotionToast.error(
            description: const Text("Cannot report. Something's wrong"),
            width: 300,
          ).show(context);
        }
      }),
      onLongPress: () async {
        await FlutterClipboard.copy(
            '${definition.myanmar}\n${definition.english}\n${definition.pali}');
        MotionToast.success(
          // title: const Text('Favourite'),
          description: const Text('ကော်ပီကူးယူပြီးပါပြီ'),
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 350,
            minHeight: 100,
            maxHeight: 100,
          ),
          animationType: AnimationType.fromBottom,
          animationDuration: const Duration(milliseconds: 500),
          toastDuration: const Duration(milliseconds: 1500),
        ).show(context);
      },
      child: Padding(
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
                    onPressed: () async {
                      final controller = ref.read(favouritesProvider.notifier);

                      if (!isInFavourites) {
                        // adding to favourites list
                        controller.addToFavourite(definition.id);
                        // show result to user with snackbark
                        MotionToast.success(
                          // title: const Text('Favourite'),
                          description: const Text(
                              'စိတ်ကြိုက်စာရင်းသို့ \nထည့်သွင်းလိုက်ပါပြီ'),
                          constraints: const BoxConstraints(
                            minWidth: 300,
                            maxWidth: 350,
                            minHeight: 100,
                            maxHeight: 100,
                          ),
                          animationType: AnimationType.fromBottom,
                          animationDuration: const Duration(milliseconds: 500),
                          toastDuration: const Duration(milliseconds: 1500),
                        ).show(context);
                        // ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(
                        //     context, 'စိတ်ကြိုက်စာရင်းသို့ ထည့်သွင်းလိုက်ပါပြီ'));
                      } else {
                        // removing from favourites list
                        controller.removeFromFavourite(definition.id);
                        // show result to user with snackbark
                        MotionToast.delete(
                          // title: const Text('Favourite'),
                          description: const Text(
                              'စိတ်ကြိုက်စာရင်းမှ \nပယ်ဖျက်လိုက်ပါပြီ'),
                          constraints: const BoxConstraints(
                            minWidth: 300,
                            maxWidth: 350,
                            minHeight: 100,
                            maxHeight: 100,
                          ),
                          animationType: AnimationType.fromBottom,
                          animationCurve: Curves.easeOut,
                          animationDuration: const Duration(milliseconds: 500),
                          toastDuration: const Duration(milliseconds: 1500),
                        ).show(context);
                        // ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(
                        //     context, 'စိတ်ကြိုက်စာရင်းမှ ပယ်ဖျက်လိုက်ပါပြီ။'));
                      }
                    },
                    icon: isInFavourites
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          )
                        : const Icon(Icons.favorite_outline))
              ],
            ),
          ),
        ),
      ),
    );
  }
/*
  SnackBar _buildSnackBar(BuildContext context, String message) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final backgroundColor = Theme.of(context).colorScheme.primary;
    return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      width: 350,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    );
  }

  */
}
