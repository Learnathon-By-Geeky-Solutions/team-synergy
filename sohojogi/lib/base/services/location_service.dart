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

  // Supabase Query Methods
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

  // Location Permission Methods
  Future<void> _checkLocationPermission() async {
    await _checkLocationService();
    await _checkAndRequestPermission();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestLocationPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  Future<LocationPermission> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
    return permission;
  }

  Future<Position> getCurrentPosition() async {
    await _checkLocationPermission();
    return await Geolocator.getCurrentPosition();
  }

  // Address Methods
  String _formatAddress(List<String?> components) {
    return components
        .where((element) => element != null && element.isNotEmpty)
        .join(', ');
  }

  Future<LocationModel> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await _getPlacemarks(latitude, longitude);
      return _createLocationFromPlacemark(placemarks.first, latitude, longitude);
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
      throw Exception('Failed to get address: $e');
    }
  }

  Future<List<Placemark>> _getPlacemarks(double latitude, double longitude) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) {
      throw Exception('No address found for these coordinates');
    }
    return placemarks;
  }

  LocationModel _createLocationFromPlacemark(
      Placemark place, double latitude, double longitude) {
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
  }

  // Save Location Methods
  Future<void> saveLocation(UserLocationModel location) async {
    try {
      await _saveToSupabaseIfAuthenticated(location);
      await _saveLocationToLocal(location);
    } catch (e) {
      debugPrint('Error saving location: $e');
      throw Exception('Failed to save location: $e');
    }
  }

  Future<void> _saveToSupabaseIfAuthenticated(UserLocationModel location) async {
    final user = _supabaseClient?.auth.currentUser;
    if (user != null) {
      await _saveLocationToSupabase(location, user.id);
    }
  }

  Future<void> _saveLocationToSupabase(
      UserLocationModel location, String userId) async {
    try {
      final locationData = _createSupabaseLocationData(location, userId);
      await _supabaseClient?.from('user_locations').insert(locationData);
    } catch (e) {
      debugPrint('Error saving to Supabase: $e');
    }
  }

  Map<String, dynamic> _createSupabaseLocationData(
      UserLocationModel location, String userId) {
    return {
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
      _createLocalLocationData(location, address),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> _createLocalLocationData(
      UserLocationModel location, String address) {
    return {
      'name': location.name,
      'address': address,
      'sub_address': location.streetAddress ?? '',
      'icon': location.icon,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'is_saved': 1,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Get Saved Locations Methods
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

      return _parseSupabaseLocations(response);
    } catch (e) {
      debugPrint('Error fetching locations from Supabase: $e');
      return [];
    }
  }

  List<LocationModel> _parseSupabaseLocations(dynamic response) {
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
      final maps = await _queryLocalSavedLocations();
      return _mapToLocationModels(maps, isSaved: true);
    } catch (e) {
      debugPrint('Error getting saved locations from local: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _queryLocalSavedLocations() async {
    final db = await _databaseHelper.database;
    return db.query('saved_locations', orderBy: 'timestamp DESC');
  }

  // Recent Locations Methods
  Future<void> addRecentLocation(LocationModel location) async {
    final db = await _databaseHelper.database;
    await _updateExistingLocation(db, location);
    await _cleanupOldLocations(db);
  }

  Future<void> _updateExistingLocation(Database db, LocationModel location) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final locationData = _createLocationData(location, timestamp);

    final existingLocation = await _findExistingLocation(db, location.address);
    if (existingLocation != null) {
      await _updateLocation(db, existingLocation['id'], timestamp);
    } else {
      await _insertLocation(db, locationData);
    }
  }

  Future<Map<String, dynamic>?> _findExistingLocation(
      Database db, String address) async {
    final locations = await db.query(
      'recent_locations',
      where: 'address = ?',
      whereArgs: [address],
    );
    return locations.isNotEmpty ? locations.first : null;
  }

  Map<String, dynamic> _createLocationData(LocationModel location, int timestamp) {
    return {
      'address': location.address,
      'sub_address': location.subAddress,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': timestamp,
    };
  }

  Future<void> _updateLocation(Database db, int id, int timestamp) async {
    await db.update(
      'recent_locations',
      {'timestamp': timestamp},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _insertLocation(
      Database db, Map<String, dynamic> locationData) async {
    await db.insert('recent_locations', locationData);
  }

  Future<void> _cleanupOldLocations(Database db) async {
    final count = await _getLocationCount(db);
    if (count != null && count > 10) {
      await _deleteOldLocations(db);
    }
  }

  Future<int?> _getLocationCount(Database db) async {
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM recent_locations'));
  }

  Future<void> _deleteOldLocations(Database db) async {
    await db.execute(
      'DELETE FROM recent_locations WHERE id NOT IN '
          '(SELECT id FROM recent_locations ORDER BY timestamp DESC LIMIT 10)',
    );
  }

  Future<List<LocationModel>> getRecentLocations() async {
    final maps = await _queryRecentLocations();
    return _mapToLocationModels(maps);
  }

  Future<List<Map<String, dynamic>>> _queryRecentLocations() async {
    try {
      final db = await _databaseHelper.database;
      return await db.query(
        'recent_locations',
        orderBy: 'timestamp DESC',
        limit: 10,
      );
    } catch (e) {
      debugPrint('Error getting recent locations: $e');
      return [];
    }
  }

  List<LocationModel> _mapToLocationModels(
      List<Map<String, dynamic>> maps, {
        bool isSaved = false,
      }) {
    return List.generate(
      maps.length,
          (i) => LocationModel(
        address: maps[i]['address'],
        subAddress: maps[i]['sub_address'] ?? '',
        name: maps[i]['name'],
        icon: maps[i]['icon'],
        isSaved: maps[i]['is_saved'] == 1 || isSaved,
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      ),
    );
  }
}