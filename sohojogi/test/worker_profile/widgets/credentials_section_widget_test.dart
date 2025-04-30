import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/credentials_section_widget.dart';
import 'package:intl/intl.dart';

void main() {
  group('CredentialsSectionWidget', () {
    late List<WorkerQualification> mockQualifications;
    late DateTime now;

    setUp(() {
      now = DateTime.now();

      mockQualifications = [
        WorkerQualification(
          id: '1',
          title: 'Test Qualification',
          issuer: 'Test Issuer',
          issueDate: now.subtract(const Duration(days: 365)),
          expiryDate: now.add(const Duration(days: 365)),
        ),
      ];
    });

    testWidgets('renders correctly with qualification data', (WidgetTester tester) async {
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
      expect(find.text('Valid'), findsOneWidget);

      // Check date formatting is working
      final dateFormat = DateFormat('MMM yyyy');
      expect(find.textContaining('Issued: ${dateFormat.format(now.subtract(const Duration(days: 365)))}'), findsOneWidget);
      expect(find.textContaining('Expires: ${dateFormat.format(now.add(const Duration(days: 365)))}'), findsOneWidget);
    });

    testWidgets('renders nothing when qualifications list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CredentialsSectionWidget(
              qualifications: [],
            ),
          ),
        ),
      );

      // Should return SizedBox.shrink() when empty
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('renders expired qualification correctly', (WidgetTester tester) async {
      final expiredQualifications = [
        WorkerQualification(
          id: '2',
          title: 'Expired Qualification',
          issuer: 'Past Issuer',
          issueDate: now.subtract(const Duration(days: 730)),
          expiryDate: now.subtract(const Duration(days: 30)),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CredentialsSectionWidget(
              qualifications: expiredQualifications,
            ),
          ),
        ),
      );

      expect(find.text('Expired Qualification'), findsOneWidget);
      expect(find.text('Past Issuer'), findsOneWidget);
      expect(find.text('Expired'), findsOneWidget);
    });

    testWidgets('renders qualification without expiry date correctly', (WidgetTester tester) async {
      final noExpiryQualifications = [
        WorkerQualification(
          id: '3',
          title: 'Permanent Certification',
          issuer: 'Permanent Issuer',
          issueDate: now.subtract(const Duration(days: 500)),
          expiryDate: null, // No expiry date
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CredentialsSectionWidget(
              qualifications: noExpiryQualifications,
            ),
          ),
        ),
      );

      expect(find.text('Permanent Certification'), findsOneWidget);
      expect(find.text('Permanent Issuer'), findsOneWidget);

      // Should not show expiry date text
      expect(find.textContaining('Expires:'), findsNothing);
    });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: Scaffold(
              body: CredentialsSectionWidget(
                qualifications: mockQualifications,
              ),
            ),
          ),
        ),
      );

      // Verify section header is rendered with correct color in dark mode
      final titleText = tester.widget<Text>(
          find.text('Qualifications & Certifications')
      );
      expect(titleText.style?.color, equals(lightColor));
    });

    testWidgets('renders multiple qualifications correctly', (WidgetTester tester) async {
      final multipleQualifications = [
        WorkerQualification(
          id: '1',
          title: 'Valid Qualification',
          issuer: 'Current Issuer',
          issueDate: now.subtract(const Duration(days: 365)),
          expiryDate: now.add(const Duration(days: 365)),
        ),
        WorkerQualification(
          id: '2',
          title: 'Expired Qualification',
          issuer: 'Past Issuer',
          issueDate: now.subtract(const Duration(days: 730)),
          expiryDate: now.subtract(const Duration(days: 30)),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CredentialsSectionWidget(
              qualifications: multipleQualifications,
            ),
          ),
        ),
      );

      // Verify both qualifications are rendered
      expect(find.text('Valid Qualification'), findsOneWidget);
      expect(find.text('Expired Qualification'), findsOneWidget);
      expect(find.text('Valid'), findsOneWidget);
      expect(find.text('Expired'), findsOneWidget);
    });
  });
}