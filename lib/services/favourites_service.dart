import 'package:mep_dictionary/services/prefs.dart';

class FavouritesService {
  List<int> get favourites =>
      Prefs.favourites.map((e) => int.parse(e)).toList();

  set favourites(List<int> favourites) =>
    Prefs.favourites = favourites.map((e) => e.toString()).toList();
  
}
