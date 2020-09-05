import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {

  static final String _assetsFolder = 'assets';
  static final String _databasePath = 'database';
  static final String _databaseName = 'mep.db';

  DatabaseProvider._();
  static final DatabaseProvider _instance = DatabaseProvider._();
  factory DatabaseProvider() => _instance;

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// Open Assets Database
  _initDatabase() async {
    print('initializing Database');
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    var exists = await databaseExists(path);
    if (!exists) {
      print('creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join(_assetsFolder, _databasePath, _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('opening existing database');
    }
    return await openDatabase(path);
  }

  Future close() async {
    return _database.close();
  }
}
