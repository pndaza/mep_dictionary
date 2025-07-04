// ignore_for_file: use_build_context_synchronously

import 'package:context_menus/context_menus.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mep_dictionary/data/constants.dart';
import 'package:mep_dictionary/screen/home/widgets/font_size_settings_controller.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/definition.dart';

class DefinitionListTile extends StatefulWidget {
  const DefinitionListTile({
    super.key,
    required this.definition,
    this.isFavourite = false,
    this.filterWord,
    this.onAddtoFavourite,
    this.onRemoveFromFavourite,
  });
  final Definition definition;
  final bool isFavourite;
  final String? filterWord;
  final VoidCallback? onAddtoFavourite;
  final VoidCallback? onRemoveFromFavourite;

  @override
  State<DefinitionListTile> createState() => _DefinitionListTileState();
}

class _DefinitionListTileState extends State<DefinitionListTile> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDarkMode ? Colors.green.shade500 : Colors.red.shade500;

    return ValueListenableBuilder(
        valueListenable: context.read<FontSizeSettingsController>().fontSize,
        builder: (_, fontSize, __) {
          // get hightlighted text
          // text style for normal text
          final defaultStyle = Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: fontSize);
          // filterd word will be highlight
          // text sytle for highlight
          final highlightStyle = TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor: Colors.yellow.withAlpha(20),
          );

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
                            EasyRichText(
                              widget.definition.myanmar,
                              defaultStyle: defaultStyle,
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: widget.filterWord ?? '',
                                  matchWordBoundaries: false,
                                  style: highlightStyle,
                                ),
                              ],
                            ),
                            EasyRichText(
                              widget.definition.english,
                              defaultStyle: defaultStyle,
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: widget.filterWord ?? '',
                                  matchWordBoundaries: false,
                                  style: highlightStyle,
                                ),
                              ],
                            ),
                            EasyRichText(
                              widget.definition.pali,
                              defaultStyle: defaultStyle,
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: widget.filterWord ?? '',
                                  matchWordBoundaries: false,
                                  style: highlightStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              isFavourite = !isFavourite;
                              if (isFavourite) {
                                widget.onAddtoFavourite?.call();
                                _showSuccessToast(context,
                                    'စိတ်ကြိုက်စာရင်းသို့ \nထည့်သွင်းလိုက်ပါပြီ');
                              } else {
                                widget.onRemoveFromFavourite?.call();
                                _showDeleteToast(context,
                                    'စိတ်ကြိုက်စာရင်းမှ\nပယ်ဖျက်လိုက်ပါပြီ');
                              }
                            });
                          },
                          icon: isFavourite
                              ? Icon(
                                  Icons.favorite,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
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
        });
  }

  void _onPressedCopyButton(BuildContext context) async {
    await Clipboard.setData(ClipboardData(
        text:
            '${widget.definition.myanmar}\n${widget.definition.english}\n${widget.definition.pali}'));

    _showSuccessToast(context, 'ကော်ပီကူးယူပြီးပါပြီ');
  }

  void _onPressedReportButton(BuildContext context) async {
    final entryParmater =
        '${widget.definition.myanmar}\n${widget.definition.english}\n${widget.definition.pali}\npage-${widget.definition.pageNumber}';
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
      description: Text(message, style: const TextStyle(color: Colors.white)),
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 350,
        minHeight: 100,
        maxHeight: 100,
      ),
      animationType: AnimationType.slideInFromTop,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(milliseconds: 1000),
    ).show(context);
  }

  void _showDeleteToast(BuildContext context, String message) {
    MotionToast.info(
      // title: const Text('Favourite'),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 350,
        minHeight: 100,
        maxHeight: 100,
      ),
      animationType: AnimationType.slideInFromBottom,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(milliseconds: 1000),
    ).show(context);
  }
}
