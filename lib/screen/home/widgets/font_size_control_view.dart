import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/providers/font_size_settings_controller.dart';

class FontSizeControlView extends ConsumerWidget {
  const FontSizeControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(fontSizeSettingsProvider.notifier);
    final fontSize = ref.watch(fontSizeSettingsProvider);
    final color = Theme.of(context).colorScheme.onPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => controller.onIncrease(),
          icon: Icon(Icons.add),
          color: color,
        ),
        Text(
          fontSize.round().toString(),
          style: TextStyle(color: color),
        ),
        IconButton(
          onPressed: () => controller.onDecrease(),
          icon: Icon(Icons.remove),
          color: color,
        ),
      ],
    );
  }
}
