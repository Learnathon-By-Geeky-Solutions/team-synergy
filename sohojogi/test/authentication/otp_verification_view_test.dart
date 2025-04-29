import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/otp_verification_view.dart';

void main() {
  testWidgets('OTPVerificationView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OTPVerificationView()));

    expect(find.text('Enter OTP'), findsOneWidget);
    expect(find.textContaining('Enter the 6-digit verification code sent to'), findsOneWidget);
    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Resend OTP'), findsOneWidget);
  });
}