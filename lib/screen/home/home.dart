import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import '../../repository/definition_repo.dart';
import 'widgets/font_size_settings_controller.dart';
import '../../services/database_provider.dart';
import '../../services/favourites_service.dart';
import '../../services/font_size_service.dart';
import 'package:provider/provider.dart';

import '../../model/definition.dart';
import '../../providers/home_controller.dart';
import 'widgets/definition_list_view.dart';
import 'widgets/search_bar.dart';
import 'widgets/settings.dart';
import 'widgets/favourite_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeViewController>(
            create: (_) => HomeViewController(
                  repository: DefinitionDatabaseRepository(DatabaseProvider()),
                  favouritesService: FavouritesService(),
                )),
        Provider<FontSizeSettingsController>(
          create: (_) => FontSizeSettingsController(FontSizeService()),
        ),
        Provider(create: (_) => FavouritesController(FavouritesService())),
      ],
      child: BackdropScaffold(
        appBar: const MyAppBar(),
        backLayer: const Settings(),
        frontLayer: const MainView(),
        stickyFrontLayer: true,
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  // final DefinitionDisplayMode displayMode;
  // final VoidCallback? onToggleDisplayMode;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeViewController>();
    return ValueListenableBuilder(
        valueListenable: controller.displayMode,
        builder: (_, displayMode, __) {
          return BackdropAppBar(
              // leading: Icon(Icons.settings),
              // elevation: 1.0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                displayMode == DefinitionDisplayMode.all
                    ? 'ဦးဟုတ်စိန် အဘိဓာန်'
                    : 'မှတ်သားစာရင်း',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: controller.onDisplayModeChanged,
                    color: Colors.white,
                    icon: displayMode == DefinitionDisplayMode.favourite
                        ? const Icon(Icons.favorite, color: Colors.white)
                        : const Icon(Icons.favorite_outline)),
                const BackdropToggleButton(
                  icon: AnimatedIcons.close_menu,
                ),
              ]);
        });
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeViewController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.state,
              builder: (_, state, __) {
                return switch (state) {
                  Loading() => const LoadingView(),
                  Empty() => EmptyInfoView(
                      info: controller.displayMode.value ==
                              DefinitionDisplayMode.favourite
                          ? 'မှတ်သားထားသည်များ မရှိသေးပါ။'
                          : 'ဘာမှ မတွေ့ပါ။',
                    ),
                  Loaded state => DefinitionListView(
                      definitions: state.definitions,
                    ),
                };
              },
            ),
          ),
          SearchFilterBar(
            searchMode: FilterMode.anywhere,
            onFilterTextChanged: (text) {
              controller.onFilterWordChanged(text);
            },
            onFilterModeChanged: (value) {
              controller.onFilterModeChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class EmptyInfoView extends StatelessWidget {
  const EmptyInfoView({super.key, this.info = 'ဘာမှ မတွေ့ပါ'});
  final String info;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(info, style: const TextStyle(fontSize: 16)),
    );
  }
}

class DataView extends StatelessWidget {
  const DataView({super.key, required this.definitions});
  final List<Definition> definitions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: DefinitionListView(definitions: definitions));
  }
}
