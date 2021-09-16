import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/services/prefs.dart';
import 'app.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.
  await Prefs.init();
  runApp(ProviderScope(child: App()));
}
