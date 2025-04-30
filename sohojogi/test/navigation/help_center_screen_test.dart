import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/navigation/app_drawer.dart';

void main() {
  group('HelpCenterScreen Widget Tests', () {
    testWidgets('HelpCenterScreen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HelpCenterScreen(),
      ));

      // Verify app bar
      expect(find.text('Help Center'), findsOneWidget);

      // Verify all help items are present
      expect(find.text('FAQs'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
      expect(find.text('Report an Issue'), findsOneWidget);
      expect(find.text('Request a Feature'), findsOneWidget);

      // Verify subtitles
      expect(find.text('Get answers to common questions'), findsOneWidget);
      expect(find.text('Reach out to our support team'), findsOneWidget);
      expect(find.text('Let us know about any problems'), findsOneWidget);
      expect(find.text('Suggest improvements to our app'), findsOneWidget);
    });

    testWidgets('Help items show snackbar on tap', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HelpCenterScreen(),
      ));

      // Tap on FAQs item
      await tester.tap(find.text('FAQs'));
      await tester.pumpAndSettle();

      // Verify snackbar appears
      expect(find.text('FAQs page coming soon'), findsOneWidget);

      // Dismiss the snackbar
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Tap on Contact Support item
      await tester.tap(find.text('Contact Support'));
      await tester.pumpAndSettle();

      // Verify snackbar appears
      expect(find.text('Contact Support page coming soon'), findsOneWidget);
    });

    testWidgets('Icons are displayed correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HelpCenterScreen(),
      ));

      // Verify icons are present
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.support_agent), findsOneWidget);
      expect(find.byIcon(Icons.bug_report), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);

      // Verify arrow icons
      expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(4));
    });
  });
}