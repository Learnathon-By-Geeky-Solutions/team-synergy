import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/business_profile/widgets/selection_modal.dart';

class TestItem {
  final String id;
  final String name;
  final bool isSelected;

  TestItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}

void main() {
  group('SelectionModal', () {
    testWidgets('renders correctly with items', (WidgetTester tester) async {
      // Create test data
      final items = [
        TestItem(id: '1', name: 'Item 1'),
        TestItem(id: '2', name: 'Item 2', isSelected: true),
        TestItem(id: '3', name: 'Item 3'),
      ];

      String toggledId = '';

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionModal<TestItem>(
              title: 'Test Selection',
              items: items,
              onToggleItem: (id) {
                toggledId = id;
              },
              itemBuilder: (context, item, isDarkMode) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(item.name),
                    selected: item.isSelected,
                    onTap: () => toggledId = item.id,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify title is displayed
      expect(find.text('Test Selection'), findsOneWidget);

      // Verify items are displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      // Verify OK button is displayed
      expect(find.text('Ok'), findsOneWidget);
    });

    testWidgets('adapts to dark mode correctly', (WidgetTester tester) async {
      // Create test data
      final items = [TestItem(id: '1', name: 'Item 1')];

      // Build widget with dark mode
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: SelectionModal<TestItem>(
                title: 'Test Selection',
                items: items,
                onToggleItem: (_) {},
                itemBuilder: (context, item, isDarkMode) {
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verify dark mode styling in title
      final titleFinder = find.text('Test Selection');
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, lightColor);
    });

    testWidgets('constrains list height correctly', (WidgetTester tester) async {
      // Set a specific screen size
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Create test data with many items to force scrolling
      final items = List.generate(
          20,
              (index) => TestItem(id: index.toString(), name: 'Item $index')
      );

      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionModal<TestItem>(
              title: 'Test Selection',
              items: items,
              onToggleItem: (_) {},
              itemBuilder: (context, item, isDarkMode) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(title: Text(item.name)),
                );
              },
            ),
          ),
        ),
      );

      // Find the list container
      final constrainedBoxFinder = find.byType(ConstrainedBox).at(1);  // Get the specific ConstrainedBox
      final constrainedBox = tester.widget<ConstrainedBox>(constrainedBoxFinder);

      // Verify height constraint exists and is appropriate
      expect(constrainedBox.constraints.maxHeight, 500.0);  // Should be half of test screen height
    });

    testWidgets('OK button closes the modal', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SelectionModal<TestItem>(
                      title: 'Test Selection',
                      items: [TestItem(id: '1', name: 'Item 1')],
                      onToggleItem: (_) {},
                      itemBuilder: (context, item, isDarkMode) {
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(title: Text(item.name)),
                        );
                      },
                    ),
                  );
                },
                child: const Text('Show Modal'),
              ),
            ),
          ),
        ),
      );

      // Open the modal
      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      // Verify the modal is shown
      expect(find.text('Test Selection'), findsOneWidget);

      // Tap the OK button
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      // Verify the modal is closed
      expect(find.text('Test Selection'), findsNothing);
    });
  });
}