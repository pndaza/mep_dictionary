// ignore_for_file: use_build_context_synchronously

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize);
    // filterd word will be highlight
    // text sytle for highlight
    final textStyleHighlight = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDarkMode ? Colors.green.shade500 : Colors.red.shade500;

    return ContextMenuRegion(
      contextMenu: SizedBox(
        width: 150,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 8,
          child: Column(
            children: [
              ListTile(
                hoverColor: hoverColor,
                title: const Text('Copy'),
                trailing: const Icon(Icons.copy),
                onTap: () {
                  context.contextMenuOverlay.hide();
                  _onPressedCopyButton(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                hoverColor: hoverColor,
                title: const Text('Report'),
                trailing: const Icon(Icons.report),
                onTap: () {
                  context.contextMenuOverlay.hide();
                  _onPressedReportButton(context);
                },
              ),
            ],
          ),
        ),
      ),
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
                        _showSuccessToast(context,
                            'စိတ်ကြိုက်စာရင်းသို့ \nထည့်သွင်းလိုက်ပါပြီ');
                      } else {
                        // removing from favourites list
                        controller.removeFromFavourite(definition.id);
                        // show result to user with snackbark
                        _showDeleteToast(
                            context, 'စိတ်ကြိုက်စာရင်းမှ\nပယ်ဖျက်လိုက်ပါပြီ');
                      }
                    },
                    icon: isInFavourites
                        ? Icon(
                            Icons.favorite,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                          )
                        : const Icon(Icons.favorite_outline))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressedCopyButton(BuildContext context) async {
    await Clipboard.setData(ClipboardData(
        text:
            '${definition.myanmar}\n${definition.english}\n${definition.pali}'));

    _showSuccessToast(context, 'ကော်ပီကူးယူပြီးပါပြီ');
  }

  void _onPressedReportButton(BuildContext context) async {
    final entryParmater =
        '${definition.myanmar}\n${definition.english}\n${definition.pali}\npage-${definition.pageNumber}';
    final url = Uri.parse(kReportUrl + entryParmater);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      MotionToast.error(
        description: const Text("Cannot report. Something's wrong."),
        width: 300,
      ).show(context);
    }
  }

  void _showSuccessToast(BuildContext context, String message) {
    MotionToast.success(
      // title: const Text('Favourite'),
      description: Text(message, style: const TextStyle(color: Colors.black)),
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
  }

  void _showDeleteToast(BuildContext context, String message) {
    MotionToast.delete(
      // title: const Text('Favourite'),
      description: Text(message, style: const TextStyle(color: Colors.black)),
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
