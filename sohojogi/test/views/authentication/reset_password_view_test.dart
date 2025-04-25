import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/reset_password_view.dart';

void main() {
  testWidgets('ResetPasswordView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));

    // Check for the title text
    expect(find.text('Reset Password').first, findsOneWidget);

    // Check for the button text
    expect(find.widgetWithText(ElevatedButton, 'Reset Password'), findsOneWidget);

    // Check for the subtitle
    expect(find.text('Enter your new password to reset it'), findsOneWidget);
  });
}