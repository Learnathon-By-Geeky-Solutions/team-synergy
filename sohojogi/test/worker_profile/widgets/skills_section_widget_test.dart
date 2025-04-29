import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/widgets/skills_section_widget.dart';

void main() {
  group('SkillsSectionWidget', () {
    const mockSkills = ['Plumbing', 'Electrical', 'Carpentry'];

    testWidgets('renders skills correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillsSectionWidget(skills: mockSkills),
          ),
        ),
      );

      expect(find.text('Skills & Expertise'), findsOneWidget);
      for (final skill in mockSkills) {
        expect(find.text(skill), findsOneWidget);
      }
    });

    testWidgets('renders empty state when no skills', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillsSectionWidget(skills: []),
          ),
        ),
      );

      expect(find.text('Skills & Expertise'), findsOneWidget);
      expect(find.byType(Chip), findsNothing);
    });
  });
}