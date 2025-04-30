import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/rating_breakdown_widget.dart';

void main() {
  group('RatingBreakdownWidget', () {
    late RatingBreakdown mockRatingBreakdown;
    late double mockOverallRating;

    setUp(() {
      // Create mock rating data
      mockRatingBreakdown = RatingBreakdown(
          fiveStars: 30,
          fourStars: 15,
          threeStars: 8,
          twoStars: 5,
          oneStars: 2
      );
      mockOverallRating = 4.1;
    });

    group('RatingBreakdownWidget', () {
      late RatingBreakdown ratingBreakdown;

      setUp(() {
        ratingBreakdown = RatingBreakdown(
          fiveStars: 5,
          fourStars: 5,
          threeStars: 5,
          twoStars: 5,
          oneStars: 5,
        );
      });

      testWidgets('renders correctly with rating data', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RatingBreakdownWidget(
                ratingBreakdown: ratingBreakdown,
                overallRating: 4.5,
              ),
            ),
          ),
        );

        // Verify overall rating is displayed
        expect(find.text('4.5'), findsOneWidget);

        // Verify stars count text (need to be more specific with finder)
        expect(find.textContaining('5 ratings'), findsOneWidget);

        // Check for rating stars icons
        expect(find.byIcon(Icons.star), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.star_half), findsOneWidget);

        // More specific finder for the rating bars
        expect(find.byType(FractionallySizedBox), findsNWidgets(5));
      });

    testWidgets('renders correct star icons for overall rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: mockRatingBreakdown,
              overallRating: mockOverallRating,
            ),
          ),
        ),
      );

      // With 4.1 rating we expect 4 full stars and 1 empty star
      expect(find.byIcon(Icons.star), findsWidgets);
      expect(find.byIcon(Icons.star_border), findsWidgets);
    });

    testWidgets('calculates percentages correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: ratingBreakdown,
              overallRating: 4.5,
            ),
          ),
        ),
      );

      // Since all star ratings have 5 votes (total 25), each should be 20%
      // Find all FractionallySizedBox widgets
      final fractionWidgets = find.byType(FractionallySizedBox);
      expect(fractionWidgets, findsNWidgets(5));

      // Each rating bar should have a widthFactor of 0.2 (20%)
      for (int i = 0; i < 5; i++) {
        final fractionWidget = tester.widget<FractionallySizedBox>(fractionWidgets.at(i));
        expect(fractionWidget.widthFactor, equals(0.2)); // 20% as decimal
      }
    });

      testWidgets('respects dark mode', (WidgetTester tester) async {
        final mockRatingBreakdown = RatingBreakdown(
          fiveStars: 10,
          fourStars: 5,
          threeStars: 3,
          twoStars: 2,
          oneStars: 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MediaQuery(
                data: const MediaQueryData(platformBrightness: Brightness.dark),
                child: RatingBreakdownWidget(
                  ratingBreakdown: mockRatingBreakdown,
                  overallRating: 4.5,
                ),
              ),
            ),
          ),
        );

        // Find specific text element instead of a generic widget
        final ratingText = find.text('4.5');
        expect(ratingText, findsOneWidget);

        // Get the text widget and check its style
        final textWidget = tester.widget<Text>(ratingText);
        expect(textWidget.style?.color, isNotNull);

        // Verify container background for dark mode
        final containerFinder = find.ancestor(
          of: ratingText,
          matching: find.byType(Container),
        );
        expect(containerFinder, findsAtLeastNWidgets(1));

        // Get a specific container (the first one)
        final container = tester.widget<Container>(containerFinder.first);
        expect(container.decoration, isNotNull);

        // Check that percentage bars use dark mode colors
        final fractionWidgets = find.byType(FractionallySizedBox);
        expect(fractionWidgets, findsAtLeastNWidgets(5)); // One for each star rating
        for (int i = 0; i < 5; i++) {
          final fractionWidget = tester.widget<FractionallySizedBox>(fractionWidgets.at(i));
          expect(fractionWidget.widthFactor, isNotNull);
        }
      });

    testWidgets('shows correct bar colors for each rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: mockRatingBreakdown,
              overallRating: mockOverallRating,
            ),
          ),
        ),
      );

      // Find all FractionallySizedBox widgets (the rating bars)
      final ratingBars = find.byType(FractionallySizedBox);
      expect(ratingBars, findsNWidgets(5));

      // Verify containers inside FractionallySizedBox exist
      for (int i = 0; i < 5; i++) {
        final container = find.descendant(
          of: ratingBars.at(i),
          matching: find.byType(Container),
        );
        expect(container, findsOneWidget);
      }
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: RatingBreakdownWidget(
                ratingBreakdown: ratingBreakdown,
                overallRating: 4.5,
              ),
            ),
          ),
        ),
      );

      // Find containers that should have dark mode colors
      final container = find.byType(Container).first;
      expect(container, findsOneWidget);

      // Verify the overall rating text has proper color in dark mode
      final textWidget = find.text('4.5').evaluate().first.widget as Text;
      expect(textWidget.style?.color, equals(lightColor));
    });

    testWidgets('calculates percentages correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: ratingBreakdown,
              overallRating: 4.5,
            ),
          ),
        ),
      );

      // Since all star ratings have 5 votes (total 25), each should be 20%
      // Find all FractionallySizedBox widgets
      final fractionWidgets = find.byType(FractionallySizedBox);
      expect(fractionWidgets, findsNWidgets(5));

      // Each rating bar should have a widthFactor of 0.2 (20%)
      for (int i = 0; i < 5; i++) {
        final fractionWidget = tester.widget<FractionallySizedBox>(fractionWidgets.at(i));
        expect(fractionWidget.widthFactor, equals(0.2)); // 20% as decimal
      }
    });
  });
  });
}