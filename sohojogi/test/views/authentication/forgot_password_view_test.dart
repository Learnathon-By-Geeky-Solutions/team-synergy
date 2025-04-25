import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/forgot_password_view.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  setUpAll(() async {
    // Mock shared_preferences
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  testWidgets('ForgotPasswordView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordView()));

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Enter your email to reset your password'), findsOneWidget);
    expect(find.text('Send Reset Email'), findsOneWidget);
  });
}