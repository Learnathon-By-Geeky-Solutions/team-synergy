import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_header_widget.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

void main() {
  group('ProfileHeaderWidget', () {
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
        reviewCount: 10,
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

    testWidgets('renders header elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(
            home: Scaffold(
              body: ProfileHeaderWidget(
                worker: mockWorker,
                isBookmarked: false,
                onBackPressed: () {},
                onBookmarkPressed: () {},
                onSharePressed: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Worker Profile'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
    });
  });
}