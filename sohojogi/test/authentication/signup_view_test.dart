import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signup_view.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  group('SignUpView Tests', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpView()));
      await tester.pumpAndSettle();

      // Check for text elements
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Welcome to SOHOJOGI\nFill the details to create your account'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Do you have an account?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // Check for input fields
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

      // Check for terms and conditions
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('shows error message on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpView()));
      await tester.pumpAndSettle();

      // Attempt to create account without entering details
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('can toggle terms acceptance', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpView()));
      await tester.pumpAndSettle();

      final checkbox = find.byType(Checkbox);
      expect(tester.widget<Checkbox>(checkbox).value, false);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(checkbox).value, true);
    });

    testWidgets('shows error for unaccepted terms', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpView()));
      await tester.pumpAndSettle();

      // Fill in form fields but don't accept terms
      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('You must accept the terms and conditions'), findsOneWidget);
    });
  });
}