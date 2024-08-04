import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_settings_controller.dart';
import 'font_size_control_view.dart';
import 'info_dialog.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
          const Divider(),
          SettingTile(
              child: ListTile(
            leading: const Icon(
              Icons.brightness_2_outlined,
              color: Colors.white,
            ),
            title: Text('Dark Mode', style: backdropTextStyle),
            trailing: Switch(
              activeColor: Colors.white,
              activeTrackColor: Colors.greenAccent,
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                context.read<ThemeSettingsController>().onToggleTheme();
              },
            ),
          )),
          SettingTile(
              child: ListTile(
            leading: const Icon(
              Icons.font_download_outlined,
              color: Colors.white,
            ),
            title: Text('Font Size', style: backdropTextStyle),
            trailing: const FontSizeControlView(),
          )),
          const Divider(),
          _InfoView(style: backdropTextStyle),
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        elevation: 6.0,
        child: child,
      ),
    );
  }
}

class _InfoView extends StatelessWidget {
  const _InfoView({required this.style});
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text('About Dictionary App', style: style),
      onTap: () async => showDialog<void>(
          context: context, builder: (_) => const InfoDialog()),
    );
  }
}
