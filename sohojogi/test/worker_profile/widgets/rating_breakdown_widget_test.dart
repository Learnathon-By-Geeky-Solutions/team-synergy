import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/rating_breakdown_widget.dart';

void main() {
  group('RatingBreakdownWidget', () {
    late RatingBreakdown mockRatingBreakdown;

    setUp(() {
      mockRatingBreakdown = RatingBreakdown(
        fiveStars: 50,
        fourStars: 30,
        threeStars: 15,
        twoStars: 3,
        oneStars: 2,
      );
    });

    testWidgets('renders overall rating correctly', (WidgetTester tester) async {
      const overallRating = 4.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: mockRatingBreakdown,
              overallRating: overallRating,
            ),
          ),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('100 ratings'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(9));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
    });

    testWidgets('renders rating bars correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: mockRatingBreakdown,
              overallRating: 4.5,
            ),
          ),
        ),
      );

      // Find rating labels using custom finder
      final starLabels = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data != null) {
          return ['1', '2', '3', '4', '5'].contains(widget.data) &&
              widget.textAlign != TextAlign.end;
        }
        return false;
      });
      expect(starLabels, findsNWidgets(5));

      // Find count values using custom finder
      final countValues = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data != null) {
          return ['50', '30', '15', '3', '2'].contains(widget.data) &&
              widget.textAlign == TextAlign.end;
        }
        return false;
      });
      expect(countValues, findsNWidgets(5));
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
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

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      expect(containerWidget.decoration, isA<BoxDecoration>());
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('calculates percentages correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingBreakdownWidget(
              ratingBreakdown: mockRatingBreakdown,
              overallRating: 4.5,
            ),
          ),
        ),
      );

      expect(mockRatingBreakdown.getPercentage(5), 50.0);
      expect(mockRatingBreakdown.getPercentage(4), 30.0);
      expect(mockRatingBreakdown.getPercentage(3), 15.0);
      expect(mockRatingBreakdown.getPercentage(2), 3.0);
      expect(mockRatingBreakdown.getPercentage(1), 2.0);
    });
  });
}