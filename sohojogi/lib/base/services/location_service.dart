// lib/base/services/location_service.dart
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

  // Fetch all countries
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await _supabaseClient?.from('countries').select().order('name');
      return (response as List).map((json) => CountryModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching countries: $e');
      return [];
    }
  }

  // Fetch states for a country
  Future<List<StateModel>> getStates(int countryId) async {
    try {
      final response = await _supabaseClient?.from('states')
          .select()
          .eq('country_id', countryId)
          .order('name');
      return (response as List).map((json) => StateModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching states: $e');
      return [];
    }
  }

  // Fetch cities for a state
  Future<List<CityModel>> getCities(int stateId) async {
    try {
      final response = await _supabaseClient?.from('cities')
          .select()
          .eq('state_id', stateId)
          .order('name');
      return (response as List).map((json) => CityModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching cities: $e');
      return [];
    }
  }

  // Fetch areas for a city
  Future<List<AreaModel>> getAreas(int cityId) async {
    try {
      final response = await _supabaseClient?.from('areas')
          .select()
          .eq('city_id', cityId)
          .order('name');
      return (response as List).map((json) => AreaModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching areas: $e');
      return [];
    }
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
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

    return await Geolocator.getCurrentPosition();
  }

  // Get address from coordinates
  Future<LocationModel> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        throw Exception('No address found for these coordinates');
      }

      Placemark place = placemarks.first;
      String address = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country
      ].where((element) => element != null && element.isNotEmpty).join(', ');

      String subAddress = [
        place.subLocality,
        place.locality
      ].where((element) => element != null && element.isNotEmpty).join(', ');

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

  // Save location to database
  Future<void> saveLocation(UserLocationModel location) async {
    try {
      final user = _supabaseClient?.auth.currentUser;

      // If user is logged in, save to Supabase
      if (user != null) {
        await _saveLocationToSupabase(location, user.id);
      }

      // Always save to local database as backup
      await _saveLocationToLocal(location);

    } catch (e) {
      debugPrint('Error saving location: $e');
      throw Exception('Failed to save location: $e');
    }
  }

  // Save location to Supabase
  Future<void> _saveLocationToSupabase(UserLocationModel location, String userId) async {
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
      // Continue with local save even if Supabase fails
    }
  }

  // Save location to local SQLite database
  Future<void> _saveLocationToLocal(UserLocationModel location) async {
    final db = await _databaseHelper.database;

    // Format address string from components
    final address = [
      location.streetAddress,
      location.areaName,
      location.cityName,
      location.stateName,
      location.countryName
    ].where((element) => element != null && element.isNotEmpty).join(', ');

    final subAddress = location.streetAddress ?? '';

    await db.insert(
      'saved_locations',
      {
        'name': location.name,
        'address': address,
        'sub_address': subAddress,
        'icon': location.icon,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'is_saved': 1,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get saved locations
  Future<List<LocationModel>> getSavedLocations() async {
    try {
      final user = _supabaseClient?.auth.currentUser;
      List<LocationModel> locations = [];

      // Try to get locations from Supabase if user is logged in
      if (user != null) {
        try {
          final response = await _supabaseClient?.from('user_locations')
              .select('*, countries(*), states(*), cities(*), areas(*)')
              .eq('user_id', user.id);

          if (response != null) {
            final userLocations = (response as List)
                .map((json) => UserLocationModel.fromJson(json))
                .toList();

            locations = userLocations.map((userLocation) => LocationModel(
              address: userLocation.formattedAddress,
              subAddress: userLocation.streetAddress ?? '',
              name: userLocation.name,
              icon: userLocation.icon,
              isSaved: true,
              latitude: userLocation.latitude,
              longitude: userLocation.longitude,
            )).toList();
          }
        } catch (e) {
          debugPrint('Error fetching locations from Supabase: $e');
          // Fall back to local database
        }
      }

      // Always get from local database and combine with Supabase results
      final localLocations = await _getSavedLocationsFromLocal();

      // Combine lists (avoiding duplicates based on address)
      final Set<String> addresses = locations.map((loc) => loc.address).toSet();
      for (var loc in localLocations) {
        if (!addresses.contains(loc.address)) {
          locations.add(loc);
          addresses.add(loc.address);
        }
      }

      return locations;
    } catch (e) {
      debugPrint('Error getting saved locations: $e');
      return [];
    }
  }

  // Get saved locations from local database
  Future<List<LocationModel>> _getSavedLocationsFromLocal() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'saved_locations',
        orderBy: 'timestamp DESC',
      );

      return List.generate(maps.length, (i) {
        return LocationModel(
          address: maps[i]['address'],
          subAddress: maps[i]['sub_address'],
          name: maps[i]['name'],
          icon: maps[i]['icon'],
          isSaved: maps[i]['is_saved'] == 1,
          latitude: maps[i]['latitude'],
          longitude: maps[i]['longitude'],
        );
      });
    } catch (e) {
      debugPrint('Error getting saved locations from local: $e');
      return [];
    }
  }

  // Add recent location
  Future<void> addRecentLocation(LocationModel location) async {
    final db = await _databaseHelper.database;

    // First check if this location already exists to avoid duplicates
    final List<Map<String, dynamic>> existingLocations = await db.query(
      'recent_locations',
      where: 'address = ?',
      whereArgs: [location.address],
    );

    if (existingLocations.isNotEmpty) {
      // Update timestamp of existing location
      await db.update(
        'recent_locations',
        {'timestamp': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [existingLocations.first['id']],
      );
    } else {
      // Insert new location
      await db.insert(
        'recent_locations',
        {
          'address': location.address,
          'sub_address': location.subAddress,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      // Limit to 10 recent locations
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM recent_locations'));
      if (count != null && count > 10) {
        await db.execute(
          'DELETE FROM recent_locations WHERE id NOT IN (SELECT id FROM recent_locations ORDER BY timestamp DESC LIMIT 10)',
        );
      }
    }
  }

  // Get recent locations
  Future<List<LocationModel>> getRecentLocations() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'recent_locations',
        orderBy: 'timestamp DESC',
        limit: 10,
      );

      return List.generate(maps.length, (i) {
        return LocationModel(
          address: maps[i]['address'],
          subAddress: maps[i]['sub_address'] ?? '',
          latitude: maps[i]['latitude'],
          longitude: maps[i]['longitude'],
          isSaved: false,
        );
      });
    } catch (e) {
      debugPrint('Error getting recent locations: $e');
      return [];
    }
  }
}