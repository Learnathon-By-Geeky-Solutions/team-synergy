import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/forgot_password_view.dart';

void main() {
  testWidgets('ForgotPasswordView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordView()));

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Enter your phone number to reset your password'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}