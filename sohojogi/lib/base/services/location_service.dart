import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_helper.dart';
import '../../screens/location/models/location_model.dart';

class LocationService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final SupabaseClient? _supabaseClient = Supabase.instance.client;

  Future<List<T>> _executeSupabaseQuery<T>({
    required String table,
    required T Function(dynamic) fromJson,
    String? equalField,
    dynamic equalValue,
  }) async {
    try {
      var query = _supabaseClient?.from(table).select();
      if (equalField != null) {
        query = query?.eq(equalField, equalValue);
      }
      final response = await query?.order('name');
      return (response as List).map((json) => fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching from $table: $e');
      return [];
    }
  }

  Future<List<CountryModel>> getCountries() async {
    return _executeSupabaseQuery(
      table: 'countries',
      fromJson: (json) => CountryModel.fromJson(json),
    );
  }

  Future<List<StateModel>> getStates(int countryId) async {
    return _executeSupabaseQuery(
      table: 'states',
      fromJson: (json) => StateModel.fromJson(json),
      equalField: 'country_id',
      equalValue: countryId,
    );
  }

  Future<List<CityModel>> getCities(int stateId) async {
    return _executeSupabaseQuery(
      table: 'cities',
      fromJson: (json) => CityModel.fromJson(json),
      equalField: 'state_id',
      equalValue: stateId,
    );
  }

  Future<List<AreaModel>> getAreas(int cityId) async {
    return _executeSupabaseQuery(
      table: 'areas',
      fromJson: (json) => AreaModel.fromJson(json),
      equalField: 'city_id',
      equalValue: cityId,
    );
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  Future<Position> getCurrentPosition() async {
    await _checkLocationPermission();
    return await Geolocator.getCurrentPosition();
  }

  String _formatAddress(List<String?> components) {
    return components
        .where((element) => element != null && element.isNotEmpty)
        .join(', ');
  }

  Future<LocationModel> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        throw Exception('No address found for these coordinates');
      }

      Placemark place = placemarks.first;
      String address = _formatAddress([
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country
      ]);

      String subAddress = _formatAddress([place.subLocality, place.locality]);

      return LocationModel(
        address: address,
        subAddress: subAddress,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
      throw Exception('Failed to get address: $e');
    }
  }

  Future<void> saveLocation(UserLocationModel location) async {
    try {
      final user = _supabaseClient?.auth.currentUser;
      if (user != null) {
        await _saveLocationToSupabase(location, user.id);
      }
      await _saveLocationToLocal(location);
    } catch (e) {
      debugPrint('Error saving location: $e');
      throw Exception('Failed to save location: $e');
    }
  }

  Future<void> _saveLocationToSupabase(
      UserLocationModel location, String userId) async {
    try {
      final locationData = {
        'user_id': userId,
        'name': location.name,
        'country_id': location.countryId,
        'state_id': location.stateId,
        'city_id': location.cityId,
        'area_id': location.areaId,
        'street_address': location.streetAddress,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'is_default': location.isDefault,
      };
      await _supabaseClient?.from('user_locations').insert(locationData);
    } catch (e) {
      debugPrint('Error saving to Supabase: $e');
    }
  }

  Future<void> _saveLocationToLocal(UserLocationModel location) async {
    final db = await _databaseHelper.database;
    final address = _formatAddress([
      location.streetAddress,
      location.areaName,
      location.cityName,
      location.stateName,
      location.countryName
    ]);

    await db.insert(
      'saved_locations',
      {
        'name': location.name,
        'address': address,
        'sub_address': location.streetAddress ?? '',
        'icon': location.icon,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'is_saved': 1,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LocationModel>> getSavedLocations() async {
    final supabaseLocations = await _getSupabaseLocations();
    final localLocations = await _getSavedLocationsFromLocal();
    return _combineLocations(supabaseLocations, localLocations);
  }

  Future<List<LocationModel>> _getSupabaseLocations() async {
    final user = _supabaseClient?.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabaseClient?.from('user_locations')
          .select('*, countries(*), states(*), cities(*), areas(*)')
          .eq('user_id', user.id);

      if (response == null) return [];

      return (response as List).map((json) {
        final userLocation = UserLocationModel.fromJson(json);
        return LocationModel(
          address: userLocation.formattedAddress,
          subAddress: userLocation.streetAddress ?? '',
          name: userLocation.name,
          icon: userLocation.icon,
          isSaved: true,
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching locations from Supabase: $e');
      return [];
    }
  }

  List<LocationModel> _combineLocations(
      List<LocationModel> supabaseLocations, List<LocationModel> localLocations) {
    final Set<String> addresses = supabaseLocations.map((loc) => loc.address).toSet();
    return [
      ...supabaseLocations,
      ...localLocations.where((loc) => !addresses.contains(loc.address))
    ];
  }

  Future<List<LocationModel>> _getSavedLocationsFromLocal() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps =
      await db.query('saved_locations', orderBy: 'timestamp DESC');

      return List.generate(maps.length, (i) => LocationModel(
        address: maps[i]['address'],
        subAddress: maps[i]['sub_address'],
        name: maps[i]['name'],
        icon: maps[i]['icon'],
        isSaved: maps[i]['is_saved'] == 1,
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      ));
    } catch (e) {
      debugPrint('Error getting saved locations from local: $e');
      return [];
    }
  }

  Future<void> addRecentLocation(LocationModel location) async {
    final db = await _databaseHelper.database;
    await _updateExistingLocation(db, location);
    await _cleanupOldLocations(db);
  }

  Future<void> _updateExistingLocation(Database db, LocationModel location) async {
    final List<Map<String, dynamic>> existingLocations = await db.query(
      'recent_locations',
      where: 'address = ?',
      whereArgs: [location.address],
    );

    if (existingLocations.isNotEmpty) {
      await db.update(
        'recent_locations',
        {'timestamp': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [existingLocations.first['id']],
      );
    } else {
      await db.insert('recent_locations', {
        'address': location.address,
        'sub_address': location.subAddress,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<void> _cleanupOldLocations(Database db) async {
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM recent_locations'));
    if (count != null && count > 10) {
      await db.execute(
        'DELETE FROM recent_locations WHERE id NOT IN '
            '(SELECT id FROM recent_locations ORDER BY timestamp DESC LIMIT 10)',
      );
    }
  }

  Future<List<LocationModel>> getRecentLocations() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'recent_locations',
        orderBy: 'timestamp DESC',
        limit: 10,
      );

      return List.generate(maps.length, (i) => LocationModel(
        address: maps[i]['address'],
        subAddress: maps[i]['sub_address'] ?? '',
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        isSaved: false,
      ));
    } catch (e) {
      debugPrint('Error getting recent locations: $e');
      return [];
    }
  }
}