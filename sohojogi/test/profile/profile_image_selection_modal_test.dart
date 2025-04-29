import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/profile/widgets/profile_image_selection_modal.dart';

void main() {
  testWidgets('ProfileImageSelectionModal shows correct options', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileImageSelectionModal(
            isDarkMode: false,
            onImageSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Change Profile Photo'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Cancel button closes modal', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ProfileImageSelectionModal(
                    isDarkMode: false,
                    onImageSelected: (_) {},
                  ),
                );
              },
              child: const Text('Show Modal'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Modal'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileImageSelectionModal), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileImageSelectionModal), findsNothing);
  });
}