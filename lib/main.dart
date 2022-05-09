import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/services/prefs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  if (Platform.isWindows || Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

  }

  // Initialize SharedPrefs instance.
  await Prefs.init();
  runApp(const ProviderScope(child: App()));
}
