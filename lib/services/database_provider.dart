import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/constants.dart';
import 'prefs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String _assetsFolder = 'assets';
  static const String _databasePath = 'database';
  static const String _databaseName = 'mep.db';

  DatabaseProvider._();
  static final DatabaseProvider _instance = DatabaseProvider._();
  factory DatabaseProvider() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

// Open Assets Database
  Future<Database> _initDatabase() async {
    // print('initializing Database');
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    final exists = await databaseExists(path);
    final savedDatabaseVersion = Prefs.databaseVersion;
    if (!exists || savedDatabaseVersion < kDatabaseVersion) {
      // print('creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // update case
      if (exists) {
        deleteDatabase(path);
        debugPrint('update mode');
      }

      // Copy from asset
      ByteData data = await rootBundle
          .load(join(_assetsFolder, _databasePath, _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      // saved db version to shared pref
      Prefs.databaseVersion = kDatabaseVersion;
    }

    return await openDatabase(path);
  }

  Future close() async {
    return _database?.close();
  }
}
