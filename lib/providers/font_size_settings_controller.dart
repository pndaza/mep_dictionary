import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/services/font_size_service.dart';

final fontSizeSettingsProvider =
    StateNotifierProvider<FontSizeSettingsController, double>(
        (ref) => FontSizeSettingsController(FontSizeService()));

class FontSizeSettingsController extends StateNotifier<double> {
  FontSizeSettingsController(this.fontSizeService)
      : super(fontSizeService.fontSize);

  final FontSizeService fontSizeService;
  double get fontSize => fontSizeService.fontSize;

  void onIncrease() {
    state++;
    fontSizeService.fontSize = state;
  }

    void onDecrease() {
    state--;
    fontSizeService.fontSize = state;
  }
}
