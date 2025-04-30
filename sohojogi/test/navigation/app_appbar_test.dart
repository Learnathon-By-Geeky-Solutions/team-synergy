import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/navigation/app_appbar.dart';


void main() {
  group('AppAppBar Tests', () {
    testWidgets('should display correct title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(),
          ),
        ),
      );

      // Assert
      expect(find.text('Sohojogi'), findsOneWidget);
    });

    testWidgets('should have notification and profile buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byIcon(Icons.person_pin), findsOneWidget);
    });

    testWidgets('should open end drawer when profile button is pressed',
            (WidgetTester tester) async {
          // Create a key to access the scaffold
          final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

          // Arrange
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                key: scaffoldKey,
                appBar: const AppAppBar(),
                endDrawer: const Drawer(),
              ),
            ),
          );

          // Act
          await tester.tap(find.byIcon(Icons.person_pin));
          await tester.pumpAndSettle();

          // Assert - verify the drawer is open
          expect(scaffoldKey.currentState!.isEndDrawerOpen, true);
        });

    testWidgets('should have correct preferred size', (WidgetTester tester) async {
      // Create the widget
      const appBar = AppAppBar();

      // Check preferred size
      expect(appBar.preferredSize, equals(const Size.fromHeight(kToolbarHeight)));
    });
  });
}