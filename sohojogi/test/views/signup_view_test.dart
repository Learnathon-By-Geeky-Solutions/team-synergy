import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/signup_view.dart';

void main() {
  testWidgets('SignUpView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Welcome to SOHOJOGI\nFill the details to create your account'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}