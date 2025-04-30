import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/splash/splash_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sohojogi/base/services/auth_gate.dart';

void main() {
  group('SplashScreen Tests', () {
    testWidgets('should render with AnimatedSplashScreen and Lottie animation',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: SplashScreen(),
            ),
          );

          // Verify core components are present
          expect(find.byType(AnimatedSplashScreen), findsOneWidget);
          expect(find.byType(LottieBuilder), findsOneWidget);

          // Instead of looking for all Center widgets, we'll verify that SizedBox exists
          // and that it contains a LottieBuilder
          final sizedBox = find.byType(SizedBox);
          expect(sizedBox, findsAtLeastNWidgets(1));
          expect(
              find.descendant(
                  of: sizedBox,
                  matching: find.byType(LottieBuilder)
              ),
              findsOneWidget
          );
        });

    testWidgets('should have correct dimensions for Lottie animation container',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: SplashScreen(),
            ),
          );

          // Find the SizedBox that's a direct ancestor of the LottieBuilder
          final sizedBox = tester.widget<SizedBox>(
            find.ancestor(
              of: find.byType(LottieBuilder),
              matching: find.byType(SizedBox),
            ).first,
          );

          expect(sizedBox.width, 125);
          expect(sizedBox.height, 125);
        });

    testWidgets('should display light theme animation in light mode',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData.light(),
              home: const SplashScreen(),
            ),
          );

          // Access the AnimatedSplashScreen widget
          final splashScreen = tester.widget<AnimatedSplashScreen>(
              find.byType(AnimatedSplashScreen)
          );

          // Verify configuration properties
          expect(splashScreen.duration, 1000);
          expect(splashScreen.splashIconSize, 400);
          expect(splashScreen.nextScreen, isA<AuthGate>());
        });

    testWidgets('should adapt to dark theme',
            (WidgetTester tester) async {
          // Test with dark theme
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData.dark(),
              home: const SplashScreen(),
            ),
          );

          // Verify the widget builds in dark mode
          expect(find.byType(SplashScreen), findsOneWidget);
          expect(find.byType(LottieBuilder), findsOneWidget);
        });
  });
}