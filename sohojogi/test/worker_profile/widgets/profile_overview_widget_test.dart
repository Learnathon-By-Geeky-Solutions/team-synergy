import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_overview_widget.dart';

void main() {
  group('ProfileOverviewWidget', () {
    final worker = WorkerProfileModel(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '1234567890',
      profileImage: 'dummy_url',
      location: 'Test City',
      latitude: 0,
      longitude: 0,
      gender: Gender.male,
      rating: 4.5,
      reviewCount: 100,
      serviceCategory: 'Plumbing',
      bio: 'Test bio',
      services: [],
      skills: [],
      availability: [],
      reviews: [],
      portfolioItems: [],
      qualifications: [],
      completionRate: 95,
      jobsCompleted: 50,
      yearsOfExperience: 5,
      isVerified: true,
    );

    testWidgets('renders worker information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: worker),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Location: Test City'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(100)'), findsOneWidget);
    });

    testWidgets('displays verification badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileOverviewWidget(worker: worker),
          ),
        ),
      );

      expect(find.byIcon(Icons.verified), findsOneWidget);
    });
  });
}