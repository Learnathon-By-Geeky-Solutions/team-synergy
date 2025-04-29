import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/forgot_password_view.dart';
import 'package:sohojogi/constants/keys.dart';


void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  group('ForgotPasswordView Tests', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordView()));
      await tester.pumpAndSettle();

      // Check for text elements
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Enter your email to reset your password'), findsOneWidget);
      expect(find.text('Send Reset Email'), findsOneWidget);

      // Check for input field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);

      // Check for back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows error message on empty email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordView()));
      await tester.pumpAndSettle();

      // Attempt to send reset email without entering email
      await tester.tap(find.text('Send Reset Email'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('navigates back on back button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const ForgotPasswordView(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordView), findsNothing);
    });

    testWidgets('shows loading indicator when sending reset email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordView()));
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(find.byType(TextField), 'test@example.com');

      // Tap send button
      await tester.tap(find.text('Send Reset Email'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

  });
}