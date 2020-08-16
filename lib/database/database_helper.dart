import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mep_dictionary/model/definition.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String table = 'definition';
  final String columnId = 'id';
  final String columnMy = 'my';
  final String columnEng = 'eng';
  final String columnPli = 'pli';
  static final String assetsFolder = 'assets';
  static final String databasePath = 'database';
  static final String databaseName = 'mep.db';

  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() => _instance;

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
    var path = join(dbPath, databaseName);
    print(path);

    var exists = await databaseExists(path);
    if (!exists) {
      print('creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join(assetsFolder, databasePath, databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('opening existing database');
    }
    // Read ONLY for dictionary
    print('opening Database ...');
    return await openDatabase(path);
  }

  Future<List<Definition>> getAllDefinitions() async {
    var dbClient = await database;
    print('called getAllDefinitions');
    if (_database == null) {
      print('database is null');
    } else {
      print('database ready');
    }
    List<Map<String, dynamic>> maps = await dbClient
        .query(table, columns: [columnId, columnMy, columnEng, columnPli]);
    // var result = await _database.rawQuery('SELECT * FROM $table');
    return List.generate(maps.length, (i) {
      return Definition.fromMap(maps[i]);
  });
  }

  Future close() async {
    return _database.close();
  }
}
