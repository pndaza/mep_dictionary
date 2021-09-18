import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/providers/theme_settings_controller.dart';
import 'package:mep_dictionary/screen/home/widgets/definition_list_view.dart';
import 'package:mep_dictionary/screen/home/widgets/info_dialog.dart';

// import 'home_controller.dart';
import '../../providers/home_controller.dart';
import 'widgets/search_bar.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = ref.watch(homeControllerProvider.notifier);
    final definitionState = ref.watch(homeViewControllerProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(child: Text('ဦးဟုတ်စိန် အဘိဓာန်')),
          actions: [
            DisplayModeToggleButton(),
            ThemeToggleButton(),
            IconButton(
                onPressed: () async => _showInfoDialog(context),
                icon: Icon(Icons.info))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: definitionState == DefinitionState.loading
              ? LoadingView()
              : DataView(),
        ));
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    return showDialog<void>(context: context, builder: (_) => InfoDialog());
  }
}

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSettingsProvider);

    return IconButton(
        onPressed: () {
          ref.read(themeSettingsProvider.notifier).onToggleTheme();
        },
        icon: themeMode == ThemeMode.dark
            ? Icon(Icons.brightness_2)
            : Icon(Icons.wb_sunny_outlined));
  }
}

class DisplayModeToggleButton extends ConsumerWidget {
  const DisplayModeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode =
        ref.read(homeViewControllerProvider.notifier).displayMode;
    return IconButton(
        onPressed: () {
          ref.read(homeViewControllerProvider.notifier).onToggleDisplayMode();
        },
        icon: displayMode == DisplayMode.favourite
            ? Icon(Icons.favorite, color: Colors.white)
            : Icon(Icons.favorite_outline));
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ဘာမှ မတွေ့ပါ'),
    );
  }
}

class DataView extends ConsumerWidget {
  const DataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitions = ref.watch(definitionsProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
              child: definitions.isEmpty
                  ? NoDataView()
                  : DefinitionListView(definitions: definitions)),
          SearchFilterBar(
            searchMode: FilterMode.Anywhere,
            onFilterTextChanged: (text) {
              ref.read(homeViewControllerProvider.notifier).onTextChanged(text);
            },
            onFilterModeChanged: (value) {
              ref
                  .read(homeViewControllerProvider.notifier)
                  .onModeChanged(value);
            },
          ),
          // SizedBox(height: 16)
        ],
      ),
    );
  }
}
