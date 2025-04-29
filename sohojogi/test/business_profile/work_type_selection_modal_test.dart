import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/business_profile/models/worker_registration_model.dart';
import 'package:sohojogi/screens/business_profile/widgets/work_type_selection_modal.dart';

void main() {
  testWidgets('WorkTypeSelectionModal displays work types correctly',
          (WidgetTester tester) async {
        // Create test data
        final workTypes = [
          WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path', isSelected: false),
          WorkTypeModel(id: '2', name: 'Electrician', icon: 'icon_path', isSelected: true),
          WorkTypeModel(id: '3', name: 'Carpenter', icon: 'icon_path', isSelected: false),
        ];

        bool toggleCalled = false;
        String toggledId = '';

        void onToggleWorkType(String id) {
          toggleCalled = true;
          toggledId = id;
        }

        // Build our widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WorkTypeSelectionModal(
                workTypes: workTypes,
                onToggleWorkType: onToggleWorkType,
              ),
            ),
          ),
        );

        // Verify the title is displayed
        expect(find.text('Select work type'), findsOneWidget);

        // Verify each work type is displayed
        expect(find.text('Plumber'), findsOneWidget);
        expect(find.text('Electrician'), findsOneWidget);
        expect(find.text('Carpenter'), findsOneWidget);

        // Verify the OK button is displayed
        expect(find.text('Ok'), findsOneWidget);

        // Tap on a work type
        await tester.tap(find.text('Plumber'));
        await tester.pump();

        // Verify the toggle callback was called
        expect(toggleCalled, true);
        expect(toggledId, '1');

        // Test OK button closes the modal
        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();
      });

  testWidgets('WorkTypeSelectionModal shows correct selection indicators',
          (WidgetTester tester) async {
        // Create test data with one selected item
        final workTypes = [
          WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path', isSelected: false),
          WorkTypeModel(id: '2', name: 'Electrician', icon: 'icon_path', isSelected: true),
        ];

        // Build our widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WorkTypeSelectionModal(
                workTypes: workTypes,
                onToggleWorkType: (_) {},
              ),
            ),
          ),
        );

        // Get all check icons (should be one for the selected item)
        final checkIcons = find.byIcon(Icons.check);
        expect(checkIcons, findsOneWidget);

        // Verify the selected work type has the correct styling
        final containers = find.byType(Container);
        bool foundSelectedContainer = false;

        for (final container in containers.evaluate()) {
          final widget = container.widget as Container;
          final decoration = widget.decoration as BoxDecoration?;
          if (decoration != null &&
              decoration.color == primaryColor &&
              decoration.shape == BoxShape.circle) {
            foundSelectedContainer = true;
            break;
          }
        }

        expect(foundSelectedContainer, true);
      });

  testWidgets('WorkTypeSelectionModal displays correct icons for work types',
          (WidgetTester tester) async {
        // Test with different work types to verify icons
        final workTypes = [
          WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path', isSelected: false),
          WorkTypeModel(id: '2', name: 'Electrician', icon: 'icon_path', isSelected: false),
          WorkTypeModel(id: '3', name: 'Carpenter', icon: 'icon_path', isSelected: false),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WorkTypeSelectionModal(
                workTypes: workTypes,
                onToggleWorkType: (_) {},
              ),
            ),
          ),
        );

        // Verify that the correct icons are shown for each work type
        expect(find.byIcon(Icons.plumbing), findsOneWidget);
        expect(find.byIcon(Icons.electrical_services), findsOneWidget);
        expect(find.byIcon(Icons.handyman), findsOneWidget);
      });
}