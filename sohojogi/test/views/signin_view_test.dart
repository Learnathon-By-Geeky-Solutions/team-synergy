import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';

void main() {
  testWidgets('SignInView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInView()));

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Welcome to SOHOJOGI\nPlease sign in to continue'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Forget Password?'), findsOneWidget);
  });
}