import 'package:flutter/foundation.dart';
import '../../../services/font_size_service.dart';


class FontSizeSettingsController {
  FontSizeSettingsController(this.fontSizeService); 
  final FontSizeService fontSizeService;
  
  late final ValueNotifier<double> _fontSize =  ValueNotifier<double>(fontSizeService.fontSize);
  ValueListenable<double> get fontSize => _fontSize;

  // double get fontSize => fontSizeService.fontSize;

  void onIncrease() {
    _fontSize.value++;
    fontSizeService.fontSize = _fontSize.value;
  }

    void onDecrease() {
    _fontSize.value--;
    fontSizeService.fontSize = _fontSize.value;
  }
}
