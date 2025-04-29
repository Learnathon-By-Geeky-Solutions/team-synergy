import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/profile/widgets/profile_save_success_modal.dart';

void main() {
  testWidgets('ProfileSaveSuccessModal shows correct content', (tester) async {
    bool okPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileSaveSuccessModal(
            onOkPressed: () => okPressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Profile Updated'), findsOneWidget);
    expect(find.text('Your profile has been updated successfully.'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    expect(okPressed, true);
  });
}