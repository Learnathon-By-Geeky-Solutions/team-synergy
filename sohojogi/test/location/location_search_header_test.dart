import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/location/view_model/location_view_model.dart';
import 'package:sohojogi/screens/location/widgets/location_search_header.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  group('LocationSearchHeader Tests', () {
    late TextEditingController searchController;
    late LocationViewModel mockViewModel;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
    });

    setUp(() {
      searchController = TextEditingController();
      mockViewModel = LocationViewModel();
    });

    tearDown(() {
      searchController.dispose();
    });

    testWidgets('renders all components correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>.value(
            value: mockViewModel,
            child: Scaffold(
              body: LocationSearchHeader(
                searchController: searchController,
                useCurrentLocation: () {},
                chooseOnMap: () {},
                isDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search for location'), findsOneWidget);
      expect(find.text('Use current location'), findsOneWidget);
      expect(find.text('Choose on map'), findsOneWidget);
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
    });

    testWidgets('handles current location tap', (WidgetTester tester) async {
      bool currentLocationCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSearchHeader(
              searchController: searchController,
              useCurrentLocation: () => currentLocationCalled = true,
              chooseOnMap: () {},
              isDarkMode: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Use current location'));
      expect(currentLocationCalled, isTrue);
    });

    testWidgets('applies dark mode styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>.value(
            value: mockViewModel,
            child: Scaffold(
              body: LocationSearchHeader(
                searchController: searchController,
                useCurrentLocation: () {},
                chooseOnMap: () {},
                isDarkMode: true,
              ),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style?.color, equals(Colors.white));
    });

    testWidgets('handles search input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>.value(
            value: mockViewModel,
            child: Scaffold(
              body: LocationSearchHeader(
                searchController: searchController,
                useCurrentLocation: () {},
                chooseOnMap: () {},
                isDarkMode: false,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test Location');
      expect(searchController.text, equals('Test Location'));
    });
  });
}