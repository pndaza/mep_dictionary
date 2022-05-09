// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

const String IS_DARK_MODE = 'is_dark_mode';
const String FAVOURITES = 'favourites';
const String FONTSIZE = 'font_size';
const String DATABASE_VERSION = 'database_version';

const bool DEFAULT_IS_DARK_MODE = false;
const List<String> DEFAULT_FAVOURITES = <String>[];
const double DEFAULT_FONTSZIE = 18.0;
const int DEFAULT_DATABASE_VERSION = 0;

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
  static set favourites(List<String> value) =>
      instance.setStringList(FAVOURITES, value);

    static double get fontSize =>
      instance.getDouble(FONTSIZE) ?? DEFAULT_FONTSZIE;
  static set fontSize(double value) => instance.setDouble(FONTSIZE, value);

  static int get databaseVersion =>
      instance.getInt(DATABASE_VERSION) ?? DEFAULT_DATABASE_VERSION;
  static set databaseVersion(int value) => instance.setInt(DATABASE_VERSION, value);
}
