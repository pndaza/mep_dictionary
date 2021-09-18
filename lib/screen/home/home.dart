import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_controller.dart';
import './widgets/definition_list_view.dart';
import './widgets/search_bar.dart';
import './widgets/settings.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = ref.watch(homeControllerProvider.notifier);
    final definitionState = ref.watch(homeViewControllerProvider);

    return BackdropScaffold(
        appBar: BackdropAppBar(
            // leading: Icon(Icons.settings),
            // elevation: 1.0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              'ဦးဟုတ်စိန် အဘိဓာန်',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            centerTitle: true,
            actions: [
              DisplayModeToggleButton(),
              BackdropToggleButton(
                icon: AnimatedIcons.close_menu,
              ),
            ]),
        stickyFrontLayer: true,
        backLayer: Settings(),
        frontLayer: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: definitionState == DefinitionState.loading
              ? LoadingView()
              : DataView(),
        ));
  }
}

class DisplayModeToggleButton extends ConsumerWidget {
  const DisplayModeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(displayModeProvider);
    print(displayMode);
    return IconButton(
        onPressed: () => ref.read(displayModeProvider.notifier).onToggle(),
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
