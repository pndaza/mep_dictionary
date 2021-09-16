import 'package:shared_preferences/shared_preferences.dart';

const String IS_DARK_MODE = 'is_dark_mode';
const String FAVOURITES = 'favourites';

const bool DEFAULT_IS_DARK_MODE = false;
const List<String> DEFAULT_FAVOURITES = <String>[];

class Prefs {
  //
  Prefs._();
  static late final SharedPreferences instance;
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

// darkmode
  static bool get isDarkMode =>
      instance.getBool(IS_DARK_MODE) ?? DEFAULT_IS_DARK_MODE;
  static set isDarkMode(bool value) => instance.setBool(IS_DARK_MODE, value);

  // favourites
  static List<String> get favourites =>
      instance.getStringList(FAVOURITES) ?? DEFAULT_FAVOURITES;
  static set favourites(List<String> value) => instance.setStringList(FAVOURITES, value);
}
