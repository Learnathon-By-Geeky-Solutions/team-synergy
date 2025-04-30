import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/navigation/app_drawer.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';

// Test implementation of ProfileViewModel
class TestProfileViewModel extends ChangeNotifier implements ProfileViewModel {
  @override
  ProfileModel profileData = ProfileModel(
    fullName: 'Test User',
    email: 'test@example.com',
  );

  @override
  File? get newProfileImage => null;

  @override
  get profileImage => null;

  @override
  get loading => false;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('should display user profile information', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => TestProfileViewModel(),
            child: const AppDrawer(),
          ),
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Text('Open Drawer'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('135 Credits'), findsOneWidget);
    expect(find.text('Expire in 21d'), findsOneWidget);
  });

  testWidgets('should display all section headers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => TestProfileViewModel(),
            child: const AppDrawer(),
          ),
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Text('Open Drawer'),
            ),
          ),
        ),
      ),
    );

    // Tap button to open drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // Check for Account and Offers (visible without scrolling)
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);

    // Scroll down to find Settings
    await tester.dragUntilVisible(
        find.text('Settings'),
        find.byType(ListView),
        const Offset(0, -100)
    );
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Scroll further down to find More
    await tester.dragUntilVisible(
        find.text('More'),
        find.byType(ListView),
        const Offset(0, -100)
    );
    await tester.pumpAndSettle();
    expect(find.text('More'), findsOneWidget);
  });

  group('AppDrawer Navigation Tests', () {
    testWidgets('should show SnackBar for coming soon features',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                drawer: ChangeNotifierProvider<ProfileViewModel>(
                  create: (_) => TestProfileViewModel(),
                  child: const AppDrawer(),
                ),
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Text('Open Drawer'),
                  ),
                ),
              ),
            ),
          );

          await tester.tap(find.text('Open Drawer'));
          await tester.pumpAndSettle();

          // Find the payment methods list tile
          final paymentMethodsFinder = find.text('Payment Methods');
          expect(paymentMethodsFinder, findsOneWidget);

          await tester.tap(paymentMethodsFinder);
          await tester.pump();

          expect(find.text('Payment Methods feature coming soon'), findsOneWidget);
        });

    testWidgets('should show theme selection dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: ChangeNotifierProvider<ProfileViewModel>(
              create: (_) => TestProfileViewModel(),
              child: const AppDrawer(),
            ),
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Text('Open Drawer'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();

      // Find and scroll to Theme
      await tester.dragUntilVisible(
          find.text('Theme'),
          find.byType(ListView),
          const Offset(0, -200)
      );
      await tester.pumpAndSettle();

      // Now we can tap on Theme
      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();

      // Verify dialog contents
      expect(find.text('Select Theme'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
    });
  });
}