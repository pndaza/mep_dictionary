import 'package:flutter/foundation.dart';
import '../../../services/favourites_service.dart';

class FavouritesController {
  FavouritesController(this.favouritesService);
  final FavouritesService favouritesService;

  late final ValueNotifier<List<int>> _favourites =
      ValueNotifier<List<int>>(favouritesService.favourites);
  ValueListenable<List<int>> get favourites => _favourites;

  void addToFavourite(int id) {
    // update state
    _favourites.value = [..._favourites.value, id];
    // save to shared preference
    favouritesService.favourites = _favourites.value;
    // final controller = read(homeViewControllerProvider.notifier);
    // final displayMode = controller.displayMode;
    // if (displayMode == DisplayMode.favourite) {
    //   controller.onFavouriteListChange();
    // }
    // debugPrint(state.toString());
  }

  void removeFromFavourite(int idToRemove) {
    // remove from state
    _favourites.value.removeWhere((id) => id == idToRemove);
    _favourites.value = [..._favourites.value];

    // save to shared preference
    favouritesService.favourites = _favourites.value;
    // read(homeControllerProvider.notifier).onFavouriteListChange();
    // final controller = read(homeControllerProvider.notifier);
    // final displayMode = controller.displayMode;
    // if (displayMode == DisplayMode.favourite) {
    //   controller.onFavouriteListChange();
    // }
    // debugPrint(state.toString());
  }

  bool isInFavourite(int id) => _favourites.value.contains(id);
}
