import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/screen/home/home_controller.dart';
import 'package:mep_dictionary/services/favourites_service.dart';

final favouritesProvider =
    StateNotifierProvider<FavouritesController, List<int>>(
        (ref) => FavouritesController(ref.read, FavouritesService()));

class FavouritesController extends StateNotifier<List<int>> {
  FavouritesController(this.read, this.favouritesService)
      : super(favouritesService.favourites);
  final FavouritesService favouritesService;
  final Reader read;

  void addToFavourite(int id) {
    // update state
    state = [...state, id];
    // save to shared preference
    favouritesService.favourites = state;
    final controller = read(homeControllerProvider.notifier);
    final displayMode = controller.definitionDisplayMode;
    if (displayMode == DefinitionDisplayMode.favourite) {
      controller.onFavouriteListChange();
    }
    print(state);
  }

  void removeFromFavourite(int id) {
    // remove from state
    state.remove(id);
    // update state
    state = [...state];
    // save to shared preference
    favouritesService.favourites = state;
    read(homeControllerProvider.notifier).onFavouriteListChange();
    final controller = read(homeControllerProvider.notifier);
    final displayMode = controller.definitionDisplayMode;
    if (displayMode == DefinitionDisplayMode.favourite) {
      controller.onFavouriteListChange();
    }
    print(state);
  }
}
