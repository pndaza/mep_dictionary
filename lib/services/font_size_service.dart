import 'prefs.dart';

class FontSizeService {
  double get fontSize => Prefs.fontSize;

  set fontSize(double value) => Prefs.fontSize = value;
}
