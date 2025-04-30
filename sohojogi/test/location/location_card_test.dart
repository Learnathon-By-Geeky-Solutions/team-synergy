import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/location/models/location_model.dart';
import 'package:sohojogi/screens/location/widgets/location_card.dart';

void main() {
  group('LocationCard Tests', () {
    testWidgets('renders saved location correctly', (WidgetTester tester) async {
      bool tapCalled = false;
      final location = LocationModel(
        address: '123 Main St',
        name: 'Home',
        icon: 'home',
        isSaved: true,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationCard(
            location: location,
            onTap: () => tapCalled = true,
            isDarkMode: false,
          ),
        ),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      expect(tapCalled, isTrue);
    });

    testWidgets('renders recent location correctly', (WidgetTester tester) async {
      final location = LocationModel(
        address: '456 Park Ave',
        subAddress: 'Apartment 2B',
        isSaved: false,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationCard(
            location: location,
            onTap: () {},
            isDarkMode: false,
          ),
        ),
      ));

      expect(find.text('456 Park Ave'), findsOneWidget);
      expect(find.text('Apartment 2B'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('applies dark mode styling', (WidgetTester tester) async {
      final location = LocationModel(
        address: 'Test Address',
        isSaved: true,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationCard(
            location: location,
            onTap: () {},
            isDarkMode: true,
          ),
        ),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, equals(Colors.grey[850]));
    });
  });
}