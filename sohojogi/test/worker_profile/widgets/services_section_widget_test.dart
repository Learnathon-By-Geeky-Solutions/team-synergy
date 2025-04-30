import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/services_section_widget.dart';

void main() {
  group('ServicesSectionWidget', () {
    late List<WorkerServiceModel> mockServices;
    late List<WorkerServiceModel> selectedServices;
    late Function(WorkerServiceModel, bool) onServiceSelected;

    setUp(() {
      mockServices = [
        WorkerServiceModel(
          id: '1',
          name: 'Basic Plumbing',
          description: 'Fix common plumbing issues',
          price: 500.0,
          unit: 'hour',
        ),
        WorkerServiceModel(
          id: '2',
          name: 'Advanced Plumbing',
          description: 'Complex plumbing solutions',
          price: 800.0,
          unit: 'job',
        ),
      ];

      selectedServices = [];

      onServiceSelected = (WorkerServiceModel service, bool isSelected) {
        if (isSelected) {
          selectedServices.add(service);
        } else {
          selectedServices.removeWhere((s) => s.id == service.id);
        }
      };
    });

    testWidgets('renders correctly with services list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServicesSectionWidget(
              services: mockServices,
              selectedServices: selectedServices,
              onServiceSelected: onServiceSelected,
            ),
          ),
        ),
      );

      expect(find.text('Services Offered'), findsOneWidget);
      expect(find.text('Select services you want to hire'), findsOneWidget);

      for (final service in mockServices) {
        expect(find.text(service.name), findsOneWidget);
        expect(find.text(service.description), findsOneWidget);
        expect(find.text('৳${service.price.toStringAsFixed(0)} per ${service.unit}'), findsOneWidget);
      }
    });

    testWidgets('renders correctly with empty services list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServicesSectionWidget(
              services: [],
              selectedServices: selectedServices,
              onServiceSelected: onServiceSelected,
            ),
          ),
        ),
      );

      expect(find.text('Services Offered'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets('correctly handles service selection', (WidgetTester tester) async {
      final List<WorkerServiceModel> testSelectedServices = [];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MaterialApp(
              home: Scaffold(
                body: ServicesSectionWidget(
                  services: mockServices,
                  selectedServices: testSelectedServices,
                  onServiceSelected: (service, isSelected) {
                    setState(() {
                      if (isSelected) {
                        testSelectedServices.add(service);
                      } else {
                        testSelectedServices.removeWhere((s) => s.id == service.id);
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pump();

      expect(find.text('1 selected'), findsOneWidget);
      expect(find.text('Total Price:'), findsOneWidget);
      expect(find.text('৳500'), findsOneWidget);

      await tester.tap(find.byType(CheckboxListTile).at(1));
      await tester.pump();

      expect(find.text('2 selected'), findsOneWidget);
      expect(find.text('৳1300'), findsOneWidget);

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pump();

      expect(find.text('1 selected'), findsOneWidget);
      expect(find.text('৳800'), findsOneWidget);
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: ServicesSectionWidget(
                services: mockServices,
                selectedServices: selectedServices,
                onServiceSelected: onServiceSelected,
              ),
            ),
          ),
        ),
      );

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      expect(containerWidget.color, equals(darkColor));

      final textFinder = find.text('Services Offered');
      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, equals(lightColor));
    });

    testWidgets('displays total price correctly', (WidgetTester tester) async {
      // Pre-select some services
      final preSelectedServices = [mockServices[0]];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServicesSectionWidget(
              services: mockServices,
              selectedServices: preSelectedServices,
              onServiceSelected: onServiceSelected,
            ),
          ),
        ),
      );

      expect(find.text('1 selected'), findsOneWidget);
      expect(find.text('Total Price:'), findsOneWidget);
      expect(find.text('৳500'), findsOneWidget);
    });

    testWidgets('service card displays correct styling when selected', (WidgetTester tester) async {
      final preSelectedServices = [mockServices[0]];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServicesSectionWidget(
              services: mockServices,
              selectedServices: preSelectedServices,
              onServiceSelected: onServiceSelected,
            ),
          ),
        ),
      );

      final cards = find.byType(Card);
      expect(cards, findsNWidgets(2));

      // Check selected card styling
      final selectedCard = tester.widget<Card>(cards.first);
      expect(selectedCard.color, equals(primaryColor.withValues(alpha: 0.1)));

      // Check unselected card styling
      final unselectedCard = tester.widget<Card>(cards.at(1));
      expect(unselectedCard.color, equals(Colors.grey.shade100));
    });

    testWidgets('service with empty description renders correctly', (WidgetTester tester) async {
      final emptyDescriptionService = [
        WorkerServiceModel(
          id: '3',
          name: 'No Description Service',
          description: '',
          price: 300.0,
          unit: 'visit',
        )
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServicesSectionWidget(
              services: emptyDescriptionService,
              selectedServices: selectedServices,
              onServiceSelected: onServiceSelected,
            ),
          ),
        ),
      );

      expect(find.text('No Description Service'), findsOneWidget);
      expect(find.text('৳300 per visit'), findsOneWidget);
    });
  });
}