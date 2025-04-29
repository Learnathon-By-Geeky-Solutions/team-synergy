import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/business_profile/models/worker_registration_model.dart';
import 'package:sohojogi/screens/business_profile/widgets/country_selection_modal.dart';

void main() {
  testWidgets('CountrySelectionModal displays countries correctly',
          (WidgetTester tester) async {
        // Create test data
        final countries = [
          CountryModel(id: '1', name: 'United States', flag: '🇺🇸', isSelected: false),
          CountryModel(id: '2', name: 'Canada', flag: '🇨🇦', isSelected: true),
          CountryModel(id: '3', name: 'United Kingdom', flag: '🇬🇧', isSelected: false),
        ];

        bool toggleCalled = false;
        String toggledId = '';

        void onToggleCountry(String id) {
          toggleCalled = true;
          toggledId = id;
        }

        // Build our widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountrySelectionModal(
                countries: countries,
                onToggleCountry: onToggleCountry,
              ),
            ),
          ),
        );

        // Verify the title is displayed
        expect(find.text('Select country'), findsOneWidget);

        // Verify each country is displayed
        expect(find.text('United States'), findsOneWidget);
        expect(find.text('Canada'), findsOneWidget);
        expect(find.text('United Kingdom'), findsOneWidget);

        // Verify flags are displayed
        expect(find.text('🇺🇸'), findsOneWidget);
        expect(find.text('🇨🇦'), findsOneWidget);
        expect(find.text('🇬🇧'), findsOneWidget);

        // Verify the OK button is displayed
        expect(find.text('Ok'), findsOneWidget);

        // Tap on a country
        await tester.tap(find.text('United States'));
        await tester.pump();

        // Verify the toggle callback was called with correct id
        expect(toggleCalled, true);
        expect(toggledId, '1');

        // Test OK button closes the modal
        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();
      });

  testWidgets('CountrySelectionModal shows correct selection indicators',
          (WidgetTester tester) async {
        // Create test data with one selected item
        final countries = [
          CountryModel(id: '1', name: 'United States', flag: '🇺🇸', isSelected: false),
          CountryModel(id: '2', name: 'Canada', flag: '🇨🇦', isSelected: true),
        ];

        // Build our widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountrySelectionModal(
                countries: countries,
                onToggleCountry: (_) {},
              ),
            ),
          ),
        );

        // Get all check icons (should be one for the selected item)
        final checkIcons = find.byIcon(Icons.check);
        expect(checkIcons, findsOneWidget);

        // Verify the selected country has the correct styling
        final containers = find.byType(Container);
        bool foundSelectedContainer = false;

        for (final container in containers.evaluate()) {
          final widget = container.widget as Container;
          final decoration = widget.decoration as BoxDecoration?;
          if (decoration != null &&
              decoration.color == primaryColor &&
              decoration.shape == BoxShape.circle) {
            foundSelectedContainer = true;
            break;
          }
        }

        expect(foundSelectedContainer, true);
      });

  testWidgets('CountrySelectionModal handles empty countries list gracefully',
          (WidgetTester tester) async {
        // Test with empty list
        final countries = <CountryModel>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountrySelectionModal(
                countries: countries,
                onToggleCountry: (_) {},
              ),
            ),
          ),
        );

        // Verify the title is still displayed even with empty list
        expect(find.text('Select country'), findsOneWidget);

        // Verify the OK button is still displayed
        expect(find.text('Ok'), findsOneWidget);
      });

  testWidgets('CountrySelectionModal handles multiple selections',
          (WidgetTester tester) async {
        // Create multiple countries
        final countries = [
          CountryModel(id: '1', name: 'United States', flag: '🇺🇸', isSelected: false),
          CountryModel(id: '2', name: 'Canada', flag: '🇨🇦', isSelected: false),
          CountryModel(id: '3', name: 'United Kingdom', flag: '🇬🇧', isSelected: false),
        ];

        String lastToggledId = '';

        // Build our widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CountrySelectionModal(
                countries: countries,
                onToggleCountry: (id) {
                  lastToggledId = id;
                  // Update selection in test data to simulate view model behavior
                  for (var country in countries) {
                    country.isSelected = country.id == id;
                  }
                },
              ),
            ),
          ),
        );

        // Tap first country
        await tester.tap(find.text('United States'));
        await tester.pump();
        expect(lastToggledId, '1');
        expect(countries[0].isSelected, true);

        // Tap second country
        await tester.tap(find.text('Canada'));
        await tester.pump();
        expect(lastToggledId, '2');
        expect(countries[0].isSelected, false); // First should be deselected
        expect(countries[1].isSelected, true);  // Second should be selected
      });
}