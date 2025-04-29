import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/credentials_section_widget.dart';

void main() {
  group('CredentialsSectionWidget', () {
    final mockQualifications = [
      WorkerQualification(
        id: '1',
        title: 'Test Qualification',
        issuer: 'Test Issuer',
        issueDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      )
    ];

    testWidgets('shows validity badge correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CredentialsSectionWidget(
              qualifications: mockQualifications,
            ),
          ),
        ),
      );

      expect(find.text('Qualifications & Certifications'), findsOneWidget);
      expect(find.text('Test Qualification'), findsOneWidget);
      expect(find.text('Test Issuer'), findsOneWidget);
    });
  });
}