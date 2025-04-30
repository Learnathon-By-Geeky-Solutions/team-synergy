import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_header_widget.dart';

void main() {
  group('ProfileHeaderWidget', () {
    late WorkerProfileModel mockWorker;
    late VoidCallback mockBackPressed;
    late VoidCallback mockBookmarkPressed;
    late VoidCallback mockSharePressed;

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
        gender: Gender.male,
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
        qualifications: [], ratingBreakdown: RatingBreakdown(
          fiveStars: 5,
          fourStars: 3,
          threeStars: 1,
          twoStars: 1,
          oneStars: 0,
        ),
      );

      mockBackPressed = () {};
      mockBookmarkPressed = () {};
      mockSharePressed = () {};
    });

    testWidgets('renders correctly in light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: false,
            onBackPressed: mockBackPressed,
            onBookmarkPressed: mockBookmarkPressed,
            onSharePressed: mockSharePressed,
          ),
        ),
      );

      // Verify title and icons
      expect(find.text('Worker Profile'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('renders bookmark icon when bookmarked', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: true,
            onBackPressed: mockBackPressed,
            onBookmarkPressed: mockBookmarkPressed,
            onSharePressed: mockSharePressed,
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
    });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: ProfileHeaderWidget(
              worker: mockWorker,
              isBookmarked: false,
              onBackPressed: mockBackPressed,
              onBookmarkPressed: mockBookmarkPressed,
              onSharePressed: mockSharePressed,
            ),
          ),
        ),
      );

      // Check that UI elements are rendered properly in dark mode
      expect(find.text('Worker Profile'), findsOneWidget);

      // Check the text color in dark mode
      final titleText = tester.widget<Text>(find.text('Worker Profile'));
      expect(titleText.style?.color, equals(lightColor));
    });

    testWidgets('calls onBackPressed when back button is tapped', (WidgetTester tester) async {
      bool backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: false,
            onBackPressed: () {
              backPressed = true;
            },
            onBookmarkPressed: mockBookmarkPressed,
            onSharePressed: mockSharePressed,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, isTrue);
    });

    testWidgets('calls onBookmarkPressed when bookmark button is tapped', (WidgetTester tester) async {
      bool bookmarkPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: false,
            onBackPressed: mockBackPressed,
            onBookmarkPressed: () {
              bookmarkPressed = true;
            },
            onSharePressed: mockSharePressed,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.bookmark_border));
      expect(bookmarkPressed, isTrue);
    });

    testWidgets('calls onSharePressed when share button is tapped', (WidgetTester tester) async {
      bool sharePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: false,
            onBackPressed: mockBackPressed,
            onBookmarkPressed: mockBookmarkPressed,
            onSharePressed: () {
              sharePressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.share));
      expect(sharePressed, isTrue);
    });

    testWidgets('bookmark icon has correct color when bookmarked', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileHeaderWidget(
            worker: mockWorker,
            isBookmarked: true,
            onBackPressed: mockBackPressed,
            onBookmarkPressed: mockBookmarkPressed,
            onSharePressed: mockSharePressed,
          ),
        ),
      );

      final bookmarkIcon = tester.widget<Icon>(find.byIcon(Icons.bookmark));
      expect(bookmarkIcon.color, equals(primaryColor));
    });

    testWidgets('bookmark icon has correct color in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: ProfileHeaderWidget(
              worker: mockWorker,
              isBookmarked: false,
              onBackPressed: mockBackPressed,
              onBookmarkPressed: mockBookmarkPressed,
              onSharePressed: mockSharePressed,
            ),
          ),
        ),
      );

      final bookmarkIcon = tester.widget<Icon>(find.byIcon(Icons.bookmark_border));
      expect(bookmarkIcon.color, equals(lightColor));
    });
  });
}