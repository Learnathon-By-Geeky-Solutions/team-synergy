import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/action_buttons_widget.dart';

void main() {
  group('ActionButtonsWidget', () {
    late WorkerProfileModel mockWorker;
    late List<WorkerServiceModel> selectedServices;
    late VoidCallback mockHirePressed;
    late bool hirePending;

    setUp(() {
      mockWorker = WorkerProfileModel(
        id: '1',
        name: 'Test Worker',
        profileImage: 'https://example.com/image.jpg',
        serviceCategory: 'Plumbing',
        location: 'Test Location',
        isVerified: true,
        rating: 4.5,
        reviewCount: 10,
        yearsOfExperience: 5,
        jobsCompleted: 25,
        completionRate: 98.5,
        bio: 'Test bio',
        skills: ['Skill 1', 'Skill 2'],
        services: [
          WorkerServiceModel(
              id: '1',
              name: 'Service 1',
              description: 'Description 1',
              price: 100,
              unit: 'hour'
          ),
        ],
        availability: [],
        qualifications: [],
        portfolioItems: [],
        ratingBreakdown: RatingBreakdown(
          fiveStars: 5,
          fourStars: 3,
          threeStars: 1,
          twoStars: 1,
          oneStars: 0,
        ),
        reviews: [], email: '', phoneNumber: '', latitude: 0.0, longitude: 0.0, gender: Gender.female,
      );

      selectedServices = [];
      mockHirePressed = () {};
      hirePending = false;
    });

    testWidgets('renders loading state when hire is pending', (WidgetTester tester) async {
      selectedServices = [
        WorkerServiceModel(
            id: '1',
            name: 'Service 1',
            description: 'Description 1',
            price: 100,
            unit: 'hour'
        ),
      ];
      hirePending = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtonsWidget(
              worker: mockWorker,
              onHirePressed: mockHirePressed,
              hirePending: hirePending,
              selectedServices: selectedServices,
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Hire Now'), findsNothing);

      // Button should be disabled while loading
      bool hirePressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtonsWidget(
              worker: mockWorker,
              onHirePressed: () => hirePressed = true,
              hirePending: hirePending,
              selectedServices: selectedServices,
            ),
          ),
        ),
      );

      // The button should contain the CircularProgressIndicator
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: Scaffold(
              body: ActionButtonsWidget(
                worker: mockWorker,
                onHirePressed: mockHirePressed,
                hirePending: hirePending,
                selectedServices: selectedServices,
              ),
            ),
          ),
        ),
      );

      // Just check that it renders without errors
      expect(find.text('Select Services First'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);

      // Verify the button colors match dark mode expectations
      final Text buttonText = tester.widget(find.text('Select Services First'));
      expect(buttonText.style?.color, isNotNull);
    });

    testWidgets('hire button has correct colors when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtonsWidget(
              worker: mockWorker,
              onHirePressed: mockHirePressed,
              hirePending: hirePending,
              selectedServices: selectedServices,
            ),
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), isNotNull);
      expect(button.onPressed, isNull);
    });

    testWidgets('hire button has correct colors when enabled', (WidgetTester tester) async {
      selectedServices = [
        WorkerServiceModel(
            id: '1',
            name: 'Service 1',
            description: 'Description 1',
            price: 100,
            unit: 'hour'
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtonsWidget(
              worker: mockWorker,
              onHirePressed: mockHirePressed,
              hirePending: hirePending,
              selectedServices: selectedServices,
            ),
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), equals(primaryColor));
      expect(button.onPressed, isNotNull);
    });
  });
}