import 'package:mep_dictionary/services/prefs.dart';

class FontSizeService {
  double get fontSize => Prefs.fontSize;

  void set fontSize(double value) => Prefs.fontSize = value;
}
