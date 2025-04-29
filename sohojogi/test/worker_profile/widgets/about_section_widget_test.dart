import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/widgets/about_section_widget.dart';

void main() {
  group('AboutSectionWidget', () {
    const String shortBio = 'A short biography';
    const String longBio = 'A very long biography that needs to be truncated. '
        'This biography contains a lot of information about the person, '
        'including their background, experience, and interests. '
        'It goes on and on, providing a detailed account of their life and work. '
        'This is just an example of a long biography that would be truncated.';


    testWidgets('renders short bio without Read More button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: shortBio),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
      expect(find.text(shortBio), findsOneWidget);
      expect(find.text('Read More'), findsNothing);
    });

    testWidgets('renders long bio with Read More button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: longBio),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Read More'), findsOneWidget);

      // Test expanding the text
      await tester.tap(find.text('Read More'));
      await tester.pump();

      expect(find.text('Show Less'), findsOneWidget);
      expect(find.text(longBio), findsOneWidget);
    });

    testWidgets('respects dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(platformBrightness: Brightness.dark),
              child: AboutSectionWidget(bio: shortBio),
            ),
          ),
        ),
      );

      final aboutText = find.text('About');
      final bioText = find.text(shortBio);

      expect(aboutText, findsOneWidget);
      expect(bioText, findsOneWidget);
    });
  });
}