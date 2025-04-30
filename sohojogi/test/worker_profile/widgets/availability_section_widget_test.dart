import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/availability_section_widget.dart';

void main() {
  group('AvailabilitySectionWidget', () {
    late List<WorkerAvailabilityDay> mockAvailability;

    setUp(() {
      mockAvailability = [
        WorkerAvailabilityDay(
          day: DayOfWeek.monday,
          available: true,
          timeSlots: [
            TimeSlot(start: '09:00 AM', end: '05:00 PM'),
          ],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.tuesday,
          available: true,
          timeSlots: [], // Available but no specific time slots
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.wednesday,
          available: false,
          timeSlots: [],
        ),
      ];
    });

    testWidgets('renders correctly with availability data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvailabilitySectionWidget(
              availability: mockAvailability,
            ),
          ),
        ),
      );

      // Check for section title
      expect(find.text('Availability'), findsOneWidget);

      // Check for day names
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);

      // Check for status indicators
      expect(find.text('09:00 AM - 05:00 PM'), findsOneWidget);
      expect(find.text('Available (contact for hours)'), findsOneWidget);
      expect(find.text('Closed'), findsOneWidget);

      // Check for footer note
      expect(find.text('Note: Availability may change based on current bookings'), findsOneWidget);
    });

    testWidgets('displays available days with time slots correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvailabilitySectionWidget(
              availability: [
                WorkerAvailabilityDay(
                  day: DayOfWeek.monday,
                  available: true,
                  timeSlots: [
                    TimeSlot(start: '09:00 AM', end: '01:00 PM'),
                    TimeSlot(start: '02:00 PM', end: '06:00 PM'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Check that both time slots are displayed
      expect(find.text('09:00 AM - 01:00 PM'), findsOneWidget);
      expect(find.text('02:00 PM - 06:00 PM'), findsOneWidget);

      // Check for check circle icon (indicating available)
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays available days without time slots correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvailabilitySectionWidget(
              availability: [
                WorkerAvailabilityDay(
                  day: DayOfWeek.friday,
                  available: true,
                  timeSlots: [],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Friday'), findsOneWidget);
      expect(find.text('Available (contact for hours)'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays unavailable days correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvailabilitySectionWidget(
              availability: [
                WorkerAvailabilityDay(
                  day: DayOfWeek.sunday,
                  available: false,
                  timeSlots: [],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Closed'), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: Scaffold(
              body: AvailabilitySectionWidget(
                availability: mockAvailability,
              ),
            ),
          ),
        ),
      );

      // Verify section header is rendered with correct icon
      expect(find.byIcon(Icons.access_time), findsOneWidget);

      // Verify section title text is rendered
      final titleText = tester.widget<Text>(find.text('Availability'));
      expect(titleText.style?.color, equals(lightColor));
    });

    testWidgets('sorts availability days by day of week', (WidgetTester tester) async {
      // Create unsorted availability list
      final unsortedAvailability = [
        WorkerAvailabilityDay(
          day: DayOfWeek.wednesday,
          available: true,
          timeSlots: [TimeSlot(start: '09:00 AM', end: '05:00 PM')],
        ),
        WorkerAvailabilityDay(
          day: DayOfWeek.monday,
          available: true,
          timeSlots: [TimeSlot(start: '08:00 AM', end: '04:00 PM')],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvailabilitySectionWidget(
              availability: unsortedAvailability,
            ),
          ),
        ),
      );

      // The widget should sort days, so Monday should appear before Wednesday
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);
    });
  });
}