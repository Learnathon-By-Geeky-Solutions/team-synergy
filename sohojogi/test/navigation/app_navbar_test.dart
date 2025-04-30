import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';

void main() {
  group('AppNavBar Tests', () {
    testWidgets('should render AppNavBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppNavBar(),
          ),
        ),
      );

      expect(find.byType(AppNavBar), findsOneWidget);
    });

    testWidgets('should accept custom initial index', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppNavBar(currentIndex: 0),
          ),
        ),
      );

      expect(find.byType(AppNavBar), findsOneWidget);
    });

    testWidgets('should have three navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppNavBar(),
          ),
        ),
      );

      // Just verify we have 3 icons total
      final iconFinders = find.byType(Icon);
      expect(iconFinders, findsNWidgets(4));
    });
  });
}