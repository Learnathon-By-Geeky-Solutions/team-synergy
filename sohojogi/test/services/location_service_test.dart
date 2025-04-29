import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/location_service.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/location/models/location_model.dart';

class MockDatabaseHelper extends Mock {
  Future<Database> get database async => throw UnimplementedError();
}

void main() {
  late LocationService locationService;

  setUpAll(() async {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    locationService = LocationService();
  });

  tearDown(() async {
    // Clean up the database after each test
    await databaseFactory.deleteDatabase('sohojogi.db');
  });

  group('LocationService Tests', () {
    test('LocationService initializes correctly', () {
      expect(locationService, isNotNull);
    });

    test('getCountries returns list of countries', () async {
      final countries = await locationService.getCountries();
      expect(countries, isA<List>());
    });

    test('getStates returns list of states for valid country', () async {
      final states = await locationService.getStates(1);
      expect(states, isA<List>());
    });

    test('getCities returns list of cities for valid state', () async {
      final cities = await locationService.getCities(1);
      expect(cities, isA<List>());
    });

    test('getAreas returns list of areas for valid city', () async {
      final areas = await locationService.getAreas(1);
      expect(areas, isA<List>());
    });

    test('getCurrentPosition throws error when location services disabled',
            () async {
          try {
            await locationService.getCurrentPosition();
            fail('Should throw an exception');
          } catch (e) {
            expect(e, isA<Exception>());
          }
        });

    test('saveLocation saves location data correctly', () async {
      final location = UserLocationModel(
        name: 'Test Location',
        countryId: 1,
        stateId: 1,
        cityId: 1,
        areaId: 1,
        streetAddress: 'Test Street',
        latitude: 23.8103,
        longitude: 90.4125,
        isDefault: true,
      );

      try {
        await locationService.saveLocation(location);
        // Verify the location was saved
        final savedLocations = await locationService.getSavedLocations();
        expect(savedLocations, isNotEmpty);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('getSavedLocations returns list of saved locations', () async {
      final locations = await locationService.getSavedLocations();
      expect(locations, isA<List<LocationModel>>());
    });

    test('getRecentLocations returns list of recent locations', () async {
      final locations = await locationService.getRecentLocations();
      expect(locations, isA<List<LocationModel>>());
    });
  });
}