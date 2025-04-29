import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/business_profile/widgets/registration_success_modal.dart';

void main() {
  group('RegistrationSuccessModal', () {
    testWidgets('renders correctly with all elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => RegistrationSuccessModal(
                      onOkPressed: () {
                      },
                    ),
                  );
                },
                child: const Text('Show Modal'),
              ),
            ),
          ),
        ),
      );

      // Open the modal
      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Registration Submitted'), findsOneWidget);
      expect(find.text('Thank you for registering as a skilled worker with us. We will get back to you soon.'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Check for success icon container
      final containers = find.byType(Container);
      bool foundSuccessContainer = false;

      for (final container in containers.evaluate()) {
        final widget = container.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        if (decoration != null &&
            decoration.shape == BoxShape.circle &&
            decoration.color == Colors.green) {
          foundSuccessContainer = true;
          break;
        }
      }

      expect(foundSuccessContainer, true);
    });

    testWidgets('calls onOkPressed when OK button is tapped', (WidgetTester tester) async {
      bool okPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: RegistrationSuccessModal(
            onOkPressed: () {
              okPressed = true;
            },
          ),
        ),
      );

      // Tap the OK button
      await tester.tap(find.text('Ok'));
      await tester.pump();

      // Verify callback was called
      expect(okPressed, true);
    });

    testWidgets('adapts to dark mode correctly', (WidgetTester tester) async {
      // Create a MediaQuery with dark mode
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: RegistrationSuccessModal(
              onOkPressed: () {},
            ),
          ),
        ),
      );

      // Verify dark mode styling
      final containers = find.byType(Container);
      bool foundDarkContainer = false;

      for (final container in containers.evaluate()) {
        final widget = container.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        if (decoration != null &&
            decoration.color == darkColor &&
            decoration.borderRadius != null) {
          foundDarkContainer = true;
          break;
        }
      }

      expect(foundDarkContainer, true);
    });

    testWidgets('has correct button styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegistrationSuccessModal(
            onOkPressed: () {},
          ),
        ),
      );

      // Find the ElevatedButton
      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Extract the button to check its properties
      final button = tester.widget<ElevatedButton>(buttonFinder);
      final buttonStyle = button.style as ButtonStyle;

      // Check button background color
      final backgroundColor = buttonStyle.backgroundColor?.resolve({});
      expect(backgroundColor, darkColor);

      // Check foreground (text) color
      final foregroundColor = buttonStyle.foregroundColor?.resolve({});
      expect(foregroundColor, Colors.amber);
    });
  });
}