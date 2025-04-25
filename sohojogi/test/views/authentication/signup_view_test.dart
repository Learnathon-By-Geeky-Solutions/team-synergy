import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/views/signup_view.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  setUpAll(() async {
    // Mock shared_preferences
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl, // Replace with your Supabase URL
      anonKey: supabaseKey, // Replace with your Supabase anon key
    );
  });

  testWidgets('SignUpView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Welcome to SOHOJOGI\nFill the details to create your account'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}