import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/widgets/services_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

void main() {
  group('ServicesSectionWidget', () {
    late List<WorkerServiceModel> mockServices;

    setUp(() {
      mockServices = [
        WorkerServiceModel(
          id: '1',
          name: 'Test Service',
          description: 'Test Description',
          price: 100.0,
          unit: 'hour',
        ),
      ];
    });

    testWidgets('renders services correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ServicesSectionWidget(
            services: mockServices,
            selectedServices: [],
            onServiceSelected: (_, __) {},
          ),
        ),
      );

      expect(find.text('Services Offered'), findsOneWidget);
      expect(find.text('Test Service'), findsOneWidget);
      expect(find.text('৳100 per hour'), findsOneWidget);
    });

    testWidgets('shows total price when services selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ServicesSectionWidget(
            services: mockServices,
            selectedServices: mockServices,
            onServiceSelected: (_, __) {},
          ),
        ),
      );

      expect(find.text('Total Price:'), findsOneWidget);
      expect(find.text('৳100'), findsOneWidget);
    });
  });
}