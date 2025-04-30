import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/service_searched_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late ServiceSearchedService searchService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    searchService = ServiceSearchedService();
  });

  group('ServiceSearchedService Tests', () {
    test('ServiceSearchedService initializes correctly', () {
      expect(searchService, isNotNull);
    });

    test('Search with empty query returns results', () async {
      final results = await searchService.searchServiceProviders(
        searchQuery: '',
        userLatitude: 23.8103,
        userLongitude: 90.4125,
      );
      expect(results, isA<List>());
    });

    test('Search with rating filter returns filtered results', () async {
      final results = await searchService.searchServiceProviders(
        searchQuery: '',
        userLatitude: 23.8103,
        userLongitude: 90.4125,
        minRating: 4.0,
      );
      for (var provider in results) {
        expect(provider.rating, greaterThanOrEqualTo(4.0));
      }
    });
  });
}