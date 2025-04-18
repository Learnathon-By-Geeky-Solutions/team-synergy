import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/views/success_view.dart';

void main() {
  testWidgets('SuccessView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SuccessView()));

    expect(find.text('Success!'), findsOneWidget);
    expect(find.text('You are all set\nYou can now sign in'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}