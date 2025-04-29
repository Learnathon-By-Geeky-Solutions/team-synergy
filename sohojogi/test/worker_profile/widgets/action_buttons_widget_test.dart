import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/action_buttons_widget.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

void main() {
  group('ActionButtonsWidget', () {
    late WorkerProfileModel mockWorker;
    late List<WorkerServiceModel> mockServices;

    setUp(() {
      mockWorker = WorkerProfileModel(
        id: '1',
        name: 'Test Worker',
        email: 'test@example.com',
        phoneNumber: '+8801234567890',
        profileImage: 'https://example.com/image.jpg',
        location: 'Test Location',
        latitude: 23.8103,
        longitude: 90.4125,
        gender: Gender.values[0],
        rating: 4.5,
        reviewCount: 10,
        serviceCategory: 'Plumbing',
        bio: 'Test bio',
        completionRate: 95.0,
        jobsCompleted: 50,
        yearsOfExperience: 5,
        isVerified: true,
        services: [],
        skills: ['Plumbing', 'Repair'],
        availability: [],
        reviews: [],
        portfolioItems: [],
        qualifications: [],
      );
      mockServices = [];
    });

    testWidgets('renders correctly with empty services', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsWidget(
            worker: mockWorker,
            onHirePressed: () {},
            hirePending: false,
            selectedServices: mockServices,
          ),
        ),
      );

      expect(find.text('Select Services First'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
    });

    testWidgets('enables hire button when services are selected', (WidgetTester tester) async {
      mockServices = [
        WorkerServiceModel(
          id: '1',
          name: 'Test Service',
          description: 'Test Description',
          price: 100.0,
          unit: 'hour',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsWidget(
            worker: mockWorker,
            onHirePressed: () {},
            hirePending: false,
            selectedServices: mockServices,
          ),
        ),
      );

      expect(find.text('Hire Now'), findsOneWidget);
      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      expect(tester.widget<ElevatedButton>(button).enabled, isTrue);
    });

    testWidgets('shows loading indicator when hire is pending', (WidgetTester tester) async {
      mockServices = [
        WorkerServiceModel(
          id: '1',
          name: 'Test Service',
          description: 'Test Description',
          price: 100.0,
          unit: 'hour',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsWidget(
            worker: mockWorker,
            onHirePressed: () {},
            hirePending: true,
            selectedServices: mockServices,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}