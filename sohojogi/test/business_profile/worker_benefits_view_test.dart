import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/business_profile/views/worker_benefits_view.dart';

void main() {
  group('WorkerBenefitsView', () {
    testWidgets('displays correct title and benefit sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WorkerBenefitsView(),
        ),
      );

      // Verify app bar and title
      expect(find.text('Worker Benefits'), findsOneWidget);
      expect(find.text('Why Join Us?'), findsOneWidget);

      // Verify benefit sections
      expect(find.text('Competitive Earnings'), findsOneWidget);
      expect(find.text('Flexible Schedule'), findsOneWidget);
      expect(find.text('Professional Growth'), findsOneWidget);
      expect(find.text('Safety & Support'), findsOneWidget);
      expect(find.text('Secure Payments'), findsOneWidget);
      expect(find.text('Build Your Reputation'), findsOneWidget);
      expect(find.text('Join Our Community'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WorkerBenefitsView(),
                      ),
                    );
                  },
                  child: const Text('Go to Benefits'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to the benefits page
      await tester.tap(find.text('Go to Benefits'));
      await tester.pumpAndSettle();

      // Verify we're on the benefits page
      expect(find.text('Worker Benefits'), findsOneWidget);

      // Press back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.text('Worker Benefits'), findsNothing);
      expect(find.text('Go to Benefits'), findsOneWidget);
    });

    testWidgets('Register Now button navigates back', (WidgetTester tester) async {
      // Set a larger surface size for testing
      await tester.binding.setSurfaceSize(const Size(800, 1000));

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WorkerBenefitsView(),
                      ),
                    );
                  },
                  child: const Text('Go to Benefits'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to the benefits page
      await tester.tap(find.text('Go to Benefits'));
      await tester.pumpAndSettle();

      // Make sure the Register Now button is visible
      await tester.ensureVisible(find.text('Register Now'));

      // Tap the Register Now button
      await tester.tap(find.text('Register Now'));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.text('Worker Benefits'), findsNothing);
      expect(find.text('Go to Benefits'), findsOneWidget);
    });
  });
}