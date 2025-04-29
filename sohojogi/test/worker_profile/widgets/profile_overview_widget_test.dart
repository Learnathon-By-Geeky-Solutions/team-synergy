import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_overview_widget.dart';

void main() {
  group('ProfileOverviewWidget', () {
    late WorkerProfileModel mockWorker;

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
        reviewCount: 100,
        serviceCategory: 'Plumbing',
        bio: 'Test bio',
        completionRate: 95.0,
        jobsCompleted: 50,
        yearsOfExperience: 5,
        isVerified: true,
        services: [],
        skills: [],
        availability: [],
        reviews: [],
        portfolioItems: [],
        qualifications: [],
      );
    });

    testWidgets('renders profile information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: mockWorker),
          ),
        ),
      );

      expect(find.text('Test Worker'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('Plumbing'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(100)'), findsOneWidget);
    });

    testWidgets('renders stats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: mockWorker),
          ),
        ),
      );

      expect(find.text('5+'), findsOneWidget); // Years of experience
      expect(find.text('50'), findsOneWidget); // Jobs completed
      expect(find.text('95.0%'), findsOneWidget); // Completion rate
      expect(find.text('Years'), findsOneWidget);
      expect(find.text('Jobs'), findsOneWidget);
      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('shows verification badge when worker is verified', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: mockWorker),
          ),
        ),
      );

      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('handles image loading error gracefully', (WidgetTester tester) async {
      final workerWithInvalidImage = WorkerProfileModel(
        id: '1',
        name: 'Test Worker',
        email: 'test@example.com',
        phoneNumber: '+8801234567890',
        profileImage: 'invalid_url',
        location: 'Test Location',
        latitude: 23.8103,
        longitude: 90.4125,
        gender: Gender.values[0],
        rating: 4.5,
        reviewCount: 100,
        serviceCategory: 'Plumbing',
        bio: 'Test bio',
        completionRate: 95.0,
        jobsCompleted: 50,
        yearsOfExperience: 5,
        isVerified: true,
        services: [],
        skills: [],
        availability: [],
        reviews: [],
        portfolioItems: [],
        qualifications: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: workerWithInvalidImage),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final grayContainer = find.byWidgetPredicate(
              (widget) => widget is Container &&
              widget.color != null &&
              widget.color == Colors.grey.shade300
      );
      expect(grayContainer, findsOneWidget);

      final personIcon = find.descendant(
        of: grayContainer,
        matching: find.byIcon(Icons.person),
      );
      expect(personIcon, findsOneWidget);
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: ProfileOverviewWidget(worker: mockWorker),
            ),
          ),
        ),
      );

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.color, isNotNull);
    });
  });
}