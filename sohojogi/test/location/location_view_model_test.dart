import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/location/models/location_model.dart';
import 'package:sohojogi/screens/location/view_model/location_view_model.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late LocationViewModel viewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    viewModel = LocationViewModel();
  });

  group('LocationViewModel basic functionality', () {
    test('initial values are correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.isSearching, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.savedLocations, isEmpty);
      expect(viewModel.recentLocations, isEmpty);
      expect(viewModel.searchResults, isEmpty);
      expect(viewModel.selectedCountry, null);
      expect(viewModel.selectedState, null);
      expect(viewModel.selectedCity, null);
      expect(viewModel.selectedArea, null);
    });

    test('setLoadingState updates loading state', () {
      viewModel.setLoadingState(true);
      expect(viewModel.isLoading, true);

      viewModel.setLoadingState(false);
      expect(viewModel.isLoading, false);
    });

    test('search updates search results and isSearching state', () {
      // Add some test locations
      viewModel.setSavedLocations([
        LocationModel(address: 'Test Address 1'),
        LocationModel(address: 'Test Address 2'),
      ]);

      // Empty search query
      viewModel.search('');
      expect(viewModel.isSearching, false);
      expect(viewModel.searchResults, isEmpty);

      // Search with query
      viewModel.search('Test');
      expect(viewModel.isSearching, true);
      expect(viewModel.searchResults.length, 2);

      // Search with specific query
      viewModel.search('1');
      expect(viewModel.isSearching, true);
      expect(viewModel.searchResults.length, 1);
    });

    test('setCountries updates countries list', () {
      final countries = [
        CountryModel(id: 1, name: 'Country 1', code: 'C1'),
        CountryModel(id: 2, name: 'Country 2', code: 'C2'),
      ];

      viewModel.setCountries(countries);
      expect(viewModel.countries, equals(countries));
    });

    test('setStates updates states list', () {
      final states = [
        StateModel(id: 1, countryId: 1, name: 'State 1'),
        StateModel(id: 2, countryId: 1, name: 'State 2'),
      ];

      viewModel.setStates(states);
      expect(viewModel.states, equals(states));
    });

    test('selectArea updates selected area', () {
      final area = AreaModel(id: 1, cityId: 1, name: 'Test Area');

      viewModel.selectArea(area);
      expect(viewModel.selectedArea, equals(area));
    });
  });
}