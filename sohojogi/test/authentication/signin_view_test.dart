import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  group('SignInView Tests', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInView()));
      await tester.pumpAndSettle();

      // Check for text elements
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Welcome to SOHOJOGI\nPlease sign in to continue'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Forget Password?'), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Check for input fields
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('shows error message on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInView()));
      await tester.pumpAndSettle();

      // Attempt to login without entering credentials
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('can toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInView()));
      await tester.pumpAndSettle();

      // Find password visibility toggle button
      final visibilityToggle = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityToggle, findsOneWidget);

      // Toggle password visibility
      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}