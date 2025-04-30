import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/home_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late HomeDatabaseService homeService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    homeService = HomeDatabaseService();
  });

  group('HomeDatabaseService Tests', () {
    test('HomeDatabaseService initializes correctly', () {
      expect(homeService, isNotNull);
    });

    test('getTopProviders returns list of providers', () async {
      final providers = await homeService.getTopProviders();
      expect(providers, isA<List>());
      // Check provider model properties
      if (providers.isNotEmpty) {
        final provider = providers.first;
        expect(provider.id, isNotNull);
        expect(provider.name, isNotNull);
        expect(provider.rating, isA<double>());
      }
    });

    test('getServiceCategories returns list of categories', () async {
      final categories = await homeService.getServiceCategories();
      expect(categories, isA<List>());
      // Verify minimum default categories
      expect(categories.length, greaterThanOrEqualTo(2));
      // Check category properties
      if (categories.isNotEmpty) {
        final category = categories.first;
        expect(category.name, isNotNull);
        expect(category.icon, isNotNull);
      }
    });
  });
}