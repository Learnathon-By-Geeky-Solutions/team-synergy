// lib/base/services/database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sohojogi/screens/location/models/location_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sohojogi_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT NOT NULL,
        sub_address TEXT,
        icon TEXT,
        latitude REAL,
        longitude REAL,
        is_saved INTEGER NOT NULL DEFAULT 1,
        timestamp INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recent_locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT NOT NULL,
        sub_address TEXT,
        latitude REAL,
        longitude REAL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }
}