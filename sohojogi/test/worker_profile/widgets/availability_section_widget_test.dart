import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/widgets/availability_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

void main() {
  group('AvailabilitySectionWidget', () {
    late List<WorkerAvailabilityDay> mockAvailability;

    setUp(() {
      mockAvailability = [
        WorkerAvailabilityDay(
          day: DayOfWeek.monday,
          available: true,
          timeSlots: [],
        ),
      ];
    });

    testWidgets('renders correctly with availability data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AvailabilitySectionWidget(
            availability: mockAvailability,
          ),
        ),
      );

      expect(find.text('Availability'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
    });
  });
}