import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trace/src/features/survey/data/models.dart';

final migrations = [
  '''
  ALTER TABLE survey ADD COLUMN created_at TEXT;
  ''',
  '''
  ALTER TABLE survey ADD COLUMN exported INTEGER;
  '''
];

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initializeDatabase();
      return _database!;
    }
  }

  Future<Database> initializeDatabase() async {
    // Get the path where the pre-existing database should be copied
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "trace_survey.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // This should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy the pre-existing database from assets
      ByteData data = await rootBundle.load(join("assets", "trace_survey.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

      var db = await openDatabase(
        path,
        readOnly: false,
      );

      print('Database version: ${await db.getVersion()}');

      // TODO: run all migrations
      return db;
    }

    print("Opening existing database");
    var db = await openDatabase(
      path,
      readOnly: false,
      version: 2, // match with # of migrations
      onUpgrade: (db, oldVersion, newVersion) async {
        print('Upgrading database from $oldVersion to $newVersion');
        if (oldVersion == 0) {
          oldVersion = 1;
        }
        for (var i = oldVersion - 1; i < newVersion; i++) {
          print('Running migration $migrations[i]');
          await db.execute(migrations[i]);
          db.setVersion(newVersion);
        }
      },
    );

    return db;
  }

  /// Get cities from database
  Future<List<City>> getCities({String? query}) async {
    final db = await database;

    List<Map<String, dynamic>> maps;

    if (query != null && query.isNotEmpty) {
      maps = await db.query('cities',
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
          orderBy: 'name',
          limit: 10);
    } else {
      maps = await db.query('cities', orderBy: 'name', limit: 10);
    }

    return List.generate(maps.length, (i) {
      return City.fromMap(maps[i]);
    });
  }

  Future<List<String>> getPlaceNames({String? query}) async {
    final db = await database;
    if (query != null && query.isNotEmpty) {
      final result = await db.rawQuery(
        'SELECT name FROM places WHERE name LIKE ?',
        ['%$query%'],
      );
      return result.map((e) => e['name'] as String).toList();
    } else {
      final result = await db.query('places', columns: ['name']);
      return result.map((e) => e['name'] as String).toList();
    }
  }

  Future<List<String>> getPlaceContacts({String? query}) async {
    final db = await database;
    if (query != null && query.isNotEmpty) {
      final result = await db.rawQuery(
        'SELECT contact FROM places WHERE contact LIKE ?',
        ['%$query%'],
      );
      return result.map((e) => e['contact'] as String).toList();
    } else {
      final result = await db.query('places', columns: ['contact']);
      return result.map((e) => e['contact'] as String).toList();
    }
  }

  /// Insert survey record into database
  Future<int> insertSurveyRecord(SurveyRecord record) async {
    final db = await database;

    return await db.insert(
      'survey',
      record.toMap(), // Convert SurveyRecord object to a Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> setAsExported(int id) async {
    final db = await database;

    return await db.update(
      'survey',
      {'exported': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SurveyRecord>> getNonExportedRecords() async {
    final db = await database;

    final result = await db.query(
      'survey',
      where: 'exported = ?',
      whereArgs: [0],
    );

    return result.map((e) => SurveyRecord.fromMap(e)).toList();
  }
}
