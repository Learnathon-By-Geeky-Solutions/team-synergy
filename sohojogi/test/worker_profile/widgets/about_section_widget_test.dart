import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/widgets/about_section_widget.dart';

void main() {
  group('AboutSectionWidget', () {
    testWidgets('renders correctly with short bio', (WidgetTester tester) async {
      const String shortBio = 'This is a short bio.';

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
      expect(find.text('Show Less'), findsNothing);
    });

    testWidgets('renders correctly with long bio and shows Read More button', (WidgetTester tester) async {
      const String longBio = 'This is a very long bio that should definitely trigger the Read More button. '
          'It contains multiple sentences to ensure it exceeds the text limits and will be truncated. '
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt '
          'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: longBio),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Read More'), findsOneWidget);
    });

    testWidgets('expands text when Read More is tapped', (WidgetTester tester) async {
      const String longBio = 'This is a very long bio that should definitely trigger the Read More button. '
          'It contains multiple sentences to ensure it exceeds the text limits and will be truncated. '
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt '
          'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: longBio),
          ),
        ),
      );

      expect(find.text('Read More'), findsOneWidget);

      await tester.tap(find.text('Read More'));
      await tester.pump();

      expect(find.text('Show Less'), findsOneWidget);
    });

    testWidgets('collapses text when Show Less is tapped', (WidgetTester tester) async {
      const String longBio = 'This is a very long bio that should definitely trigger the Read More button. '
          'It contains multiple sentences to ensure it exceeds the text limits and will be truncated. '
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt '
          'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: longBio),
          ),
        ),
      );

      await tester.tap(find.text('Read More'));
      await tester.pump();

      expect(find.text('Show Less'), findsOneWidget);

      await tester.tap(find.text('Show Less'));
      await tester.pump();

      expect(find.text('Read More'), findsOneWidget);
    });

    testWidgets('handles bio with newlines correctly', (WidgetTester tester) async {
      const String bioWithNewlines = 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutSectionWidget(bio: bioWithNewlines),
          ),
        ),
      );

      expect(find.text('Read More'), findsOneWidget);
    });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      const String bio = 'Test bio';

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(platformBrightness: Brightness.dark),
          child: MaterialApp(
            home: Scaffold(
              body: AboutSectionWidget(bio: bio),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, equals(darkColor));

      final titleText = tester.widget<Text>(find.text('About'));
      expect(titleText.style?.color, equals(lightColor));

      final bioText = tester.widget<Text>(find.text(bio));
      expect(bioText.style?.color, equals(lightGrayColor));
    });

    testWidgets('renders correctly in light mode', (WidgetTester tester) async {
      const String bio = 'Test bio';

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(platformBrightness: Brightness.light),
          child: MaterialApp(
            home: Scaffold(
              body: AboutSectionWidget(bio: bio),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, equals(lightColor));

      final titleText = tester.widget<Text>(find.text('About'));
      expect(titleText.style?.color, equals(darkColor));

      final bioText = tester.widget<Text>(find.text(bio));
      expect(bioText.style?.color, equals(grayColor));
    });
  });
}