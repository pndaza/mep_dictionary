import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'font_size_settings_controller.dart';

class FontSizeControlView extends StatelessWidget {
  const FontSizeControlView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FontSizeSettingsController>();
    final primaryColor = Theme.of(context).colorScheme.onPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => controller.onDecrease(),
          icon: const Icon(Icons.remove),
          color: primaryColor,
        ),
        ValueListenableBuilder(
            valueListenable: controller.fontSize,
            builder: (_, fontSize, __) {
              return Text(
                fontSize.toString(),
                style: TextStyle(color: primaryColor),
              );
            }),
        IconButton(
          onPressed: () => controller.onIncrease(),
          icon: const Icon(Icons.add),
          color: primaryColor,
        ),
      ],
    );
  }
}
