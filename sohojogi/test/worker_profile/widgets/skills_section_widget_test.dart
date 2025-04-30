import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/widgets/skills_section_widget.dart';

void main() {
  group('SkillsSectionWidget', () {
    const List<String> mockSkills = ['Plumbing', 'Repair', 'Installation'];

    testWidgets('renders skill section title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillsSectionWidget(skills: mockSkills),
          ),
        ),
      );

      expect(find.text('Skills & Expertise'), findsOneWidget);
    });

    testWidgets('renders all skill chips correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillsSectionWidget(skills: mockSkills),
          ),
        ),
      );

      // Check that all skills are displayed
      for (final skill in mockSkills) {
        expect(find.text(skill), findsOneWidget);
      }

      // Verify chip count matches skills count
      expect(find.byType(Chip), findsNWidgets(mockSkills.length));
    });

    testWidgets('renders correctly with empty skills list', (WidgetTester tester) async {
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

    testWidgets('adapts to dark mode correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(platformBrightness: Brightness.dark),
              child: SkillsSectionWidget(skills: mockSkills),
            ),
          ),
        ),
      );

      // Find the container and text to verify dark mode styling
      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      // Verify the chips appear in dark mode
      expect(find.byType(Chip), findsNWidgets(mockSkills.length));

      // Get a chip to verify its styling
      final chip = tester.widget<Chip>(find.byType(Chip).first);
      final chipText = chip.label as Text;

      // Verify the text color is set for dark mode
      expect((chipText.style?.color), isNotNull);
    });

    testWidgets('chip has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillsSectionWidget(skills: mockSkills),
          ),
        ),
      );

      // Check chip properties
      final chip = tester.widget<Chip>(find.byType(Chip).first);

      // Verify text is displayed with expected styling
      expect(chip.label, isA<Text>());
      final labelText = chip.label as Text;
      expect(labelText.data, equals(mockSkills[0]));
      expect(labelText.style?.fontSize, 12);

      // Verify chip padding is as expected
      expect(chip.padding, const EdgeInsets.symmetric(horizontal: 8, vertical: 0));

      // Verify tap target size
      expect(chip.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);

      // Verify background color
      expect(chip.backgroundColor, isA<Color>());
    });

    testWidgets('wrap widget handles multiple chips correctly', (WidgetTester tester) async {
      const longSkillsList = ['Plumbing', 'Electrical', 'Carpentry', 'Painting',
        'Masonry', 'Tiling', 'Roofing', 'Landscaping'];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Constrained width to force wrapping
              child: SkillsSectionWidget(skills: longSkillsList),
            ),
          ),
        ),
      );

      // Verify all skills are rendered
      expect(find.byType(Chip), findsNWidgets(longSkillsList.length));

      // Verify the Wrap widget is used
      expect(find.byType(Wrap), findsOneWidget);

      // Check Wrap properties
      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 8);
      expect(wrap.runSpacing, 8);
    });
  });
}