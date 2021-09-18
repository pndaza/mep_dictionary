import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/providers/theme_settings_controller.dart';

import 'font_size_control_view.dart';
import 'info_dialog.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backdropTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary);

    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: 250,
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 8.0,
              child: ListTile(
                leading: Icon(
                  Icons.brightness_2_outlined,
                  color: Colors.white,
                ),
                title: Text('Dark Mode', style: backdropTextStyle),
                trailing: _ThemeToggleSwitch(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 8.0,
              child: ListTile(
                leading: Icon(
                  Icons.font_download_outlined,
                  color: Colors.white,
                ),
                title: Text('Font Size', style: backdropTextStyle),
                trailing: FontSizeControlView(),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: Text('About Dictionary App', style: backdropTextStyle),
            onTap: () async => showDialog<void>(
                context: context, builder: (_) => InfoDialog()),
          ),
        ],
      ),
    );
  }
}

class _ThemeToggleSwitch extends ConsumerWidget {
  const _ThemeToggleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSettingsProvider);
    final bool isDarkMode = themeMode == ThemeMode.dark;

    return Switch(
        value: isDarkMode,
        onChanged: (newValue) {
          ref.read(themeSettingsProvider.notifier).onToggleTheme();
        });
  }
}
