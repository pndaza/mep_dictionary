import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_controller.dart';
import './widgets/definition_list_view.dart';
import './widgets/search_bar.dart';
import './widgets/settings.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

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
          actions: const [
            DisplayModeToggleButton(),
            BackdropToggleButton(
              icon: AnimatedIcons.close_menu,
            ),
          ]),
      stickyFrontLayer: true,
      backLayer: const Settings(),
      frontLayer: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            Expanded(
              child: definitionState == DefinitionState.loading
                  ? const LoadingView()
                  : const DataView(),
            ),
            SearchFilterBar(
              searchMode: FilterMode.anywhere,
              onFilterTextChanged: (text) {
                ref
                    .read(homeViewControllerProvider.notifier)
                    .onTextChanged(text);
              },
              onFilterModeChanged: (value) {
                ref
                    .read(homeViewControllerProvider.notifier)
                    .onModeChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayModeToggleButton extends ConsumerWidget {
  const DisplayModeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(displayModeProvider);
    // debugPrint(displayMode.toString());
    return IconButton(
        onPressed: () => ref.read(displayModeProvider.notifier).onToggle(),
        icon: displayMode == DisplayMode.favourite
            ? const Icon(Icons.favorite, color: Colors.white)
            : const Icon(Icons.favorite_outline));
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
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
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: definitions.isEmpty
            ? const NoDataView()
            : DefinitionListView(definitions: definitions));
  }
}
