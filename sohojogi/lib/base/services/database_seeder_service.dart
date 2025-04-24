import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/location_seed_data.dart';

class DatabaseSeederService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ValueNotifier<String> progressNotifier = ValueNotifier<String>('');
  final ValueNotifier<double> progressValue = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> isSeeding = ValueNotifier<bool>(false);

  Future<void> seedLocationData() async {
    isSeeding.value = true;
    progressNotifier.value = 'Starting database seeding...';
    progressValue.value = 0.0;

    try {
      // Clear existing data if needed
      progressNotifier.value = 'Clearing existing data...';
      await _clearExistingData();

      // Insert countries
      progressNotifier.value = 'Inserting countries...';
      progressValue.value = 0.1;
      final Map<String, int> countryIds = await _insertCountries();

      // Insert states
      progressNotifier.value = 'Inserting states/provinces...';
      progressValue.value = 0.3;
      final Map<String, int> stateIds = await _insertStates(countryIds);

      // Insert cities
      progressNotifier.value = 'Inserting cities...';
      progressValue.value = 0.6;
      final Map<String, int> cityIds = await _insertCities(stateIds);

      // Insert areas
      progressNotifier.value = 'Inserting areas/localities...';
      progressValue.value = 0.9;
      await _insertAreas(cityIds);

      progressNotifier.value = 'Database seeding completed successfully!';
      progressValue.value = 1.0;
    } catch (e) {
      progressNotifier.value = 'Error seeding database: $e';
    } finally {
      isSeeding.value = false;
    }
  }

  Future<void> _clearExistingData() async {
    // Delete in reverse order to respect foreign key constraints
    await _supabase.from('areas').delete().neq('id', 0);
    await _supabase.from('cities').delete().neq('id', 0);
    await _supabase.from('states').delete().neq('id', 0);
    await _supabase.from('countries').delete().neq('id', 0);
  }

  Future<Map<String, int>> _insertCountries() async {
    final Map<String, int> countryIds = {};

    for (var country in locationSeedData.keys) {
      final data = locationSeedData[country]!;

      final response = await _supabase.from('countries').insert({
        'name': country,
        'code': data['code'],
        'flag': data['flag'],
      }).select('id').single();

      countryIds[country] = response['id'];
    }

    return countryIds;
  }

  Future<Map<String, int>> _insertStates(Map<String, int> countryIds) async {
    final Map<String, int> stateIds = {};

    for (var country in locationSeedData.keys) {
      final countryId = countryIds[country];
      final statesData = locationSeedData[country]!['states'] as Map<String, dynamic>;

      for (var state in statesData.keys) {
        final response = await _supabase.from('states').insert({
          'country_id': countryId,
          'name': state,
          'code': statesData[state]['code'] ?? '',
        }).select('id').single();

        stateIds['$country-$state'] = response['id'];
      }
    }

    return stateIds;
  }

  Future<Map<String, int>> _insertCities(Map<String, int> stateIds) async {
    final Map<String, int> cityIds = {};

    for (var country in locationSeedData.keys) {
      final statesData = locationSeedData[country]!['states'] as Map<String, dynamic>;

      for (var state in statesData.keys) {
        final stateId = stateIds['$country-$state'];
        final citiesData = statesData[state]['cities'] as Map<String, dynamic>? ?? {};

        for (var city in citiesData.keys) {
          final response = await _supabase.from('cities').insert({
            'state_id': stateId,
            'name': city,
            'code': citiesData[city]['code'] ?? '',
          }).select('id').single();

          cityIds['$country-$state-$city'] = response['id'];
        }
      }
    }

    return cityIds;
  }

  Future<void> _insertAreas(Map<String, int> cityIds) async {
    for (var country in locationSeedData.keys) {
      final statesData = locationSeedData[country]!['states'] as Map<String, dynamic>;

      for (var state in statesData.keys) {
        final citiesData = statesData[state]['cities'] as Map<String, dynamic>? ?? {};

        for (var city in citiesData.keys) {
          final cityId = cityIds['$country-$state-$city'];
          final areasData = citiesData[city]['areas'] as List<Map<String, dynamic>>? ?? [];

          for (var area in areasData) {
            await _supabase.from('areas').insert({
              'city_id': cityId,
              'name': area['name'],
              'postal_code': area['postal_code'] ?? '',
            });
          }
        }
      }
    }
  }
}