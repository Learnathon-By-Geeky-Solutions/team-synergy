import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sohojogi/base/services/database_helper.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseHelper = DatabaseHelper();
  });

  group('DatabaseHelper Tests', () {
    test('Database initializes correctly', () async {
      final db = await databaseHelper.database;
      expect(db, isNotNull);
    });

    test('Database creates required tables', () async {
      final db = await databaseHelper.database;

      final savedLocations = await db.query('saved_locations');
      expect(savedLocations, isA<List>());

      final recentLocations = await db.query('recent_locations');
      expect(recentLocations, isA<List>());
    });
  });
}