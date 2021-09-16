import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/services/favourites_service.dart';

final favouritesProvider =
    StateNotifierProvider<FavouritesController, List<int>>(
        (ref) => FavouritesController(FavouritesService()));

class FavouritesController extends StateNotifier<List<int>> {
  FavouritesController(this.favouritesService)
      : super(favouritesService.favourites);
  final FavouritesService favouritesService;

  void onFavouriteChanged(int id) {
    final favourites = state;
    if (favourites.contains(id)) {
      favourites.remove(id);
    } else {
      favourites.add(id);
    }
// update state
    state = favourites;

    favouritesService.favourites = favourites;
    print(favourites);
  }
}
