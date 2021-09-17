import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/model/definition.dart';
import 'package:mep_dictionary/screen/home/theme_settings_controller.dart';
import 'package:mep_dictionary/screen/home/widgets/definition_list_view.dart';
import 'package:mep_dictionary/screen/home/widgets/info_dialog.dart';

import 'home_controller.dart';
import 'widgets/search_bar.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = ref.watch(homeControllerProvider.notifier);
    final definitionState = ref.watch(homeControllerProvider);
    final themeMode = ref.watch(themeSettingsProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(child: Text('ဦးဟုတ်စိန် အဘိဓာန်')),
          actions: [
            IconButton(
                onPressed: () {
                  ref
                      .read(homeControllerProvider.notifier)
                      .onDisplayModeChanged();
                },
                icon: notifier.definitionDisplayMode ==
                        DefinitionDisplayMode.favourite
                    ? Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )
                    : Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {
                  ref.read(themeSettingsProvider.notifier).toggleTheme();
                },
                icon: themeMode == ThemeMode.dark
                    ? Icon(
                        Icons.brightness_2,
                      )
                    : Icon(Icons.wb_sunny_outlined)),
            IconButton(
                onPressed: () async => _showInfoDialog(context),
                icon: Icon(Icons.info))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: definitionState.when(
                      loading: () => LoadingView(),
                      noData: () => NoDataView(),
                      data: (definitions) =>
                          DefinitionListView(definitions: definitions))),
              SearchFilterBar(
                searchMode: FilterMode.Anywhere,
                onFilterTextChanged: (text) {
                  ref.read(homeControllerProvider.notifier).onTextChanged(text);
                },
                onFilterModeChanged: (value) {
                  ref
                      .read(homeControllerProvider.notifier)
                      .onModeChanged(value);
                },
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }

  Future<void> _showInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return InfoDialog();
      },
    );
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
  const DataView({Key? key, required this.definitions}) : super(key: key);
  final List<Definition> definitions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ref.read(homeControllerProvider.notifier).onTextChanged(text);
            },
            onFilterModeChanged: (value) {
              ref.read(homeControllerProvider.notifier).onModeChanged(value);
            },
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
