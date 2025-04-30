import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/widgets/filter_bottom_sheet.dart';

void main() {
  final List<String> testCategories = ['Plumbing', 'Electrical', 'Cleaning'];

  testWidgets('FilterBottomSheetWidget displays initial filters correctly',
          (WidgetTester tester) async {
        // Setup initial filters
        final initialFilters = {
          'minRating': 3.5,
          'categories': ['Plumbing'],
          'sortBy': 'Distance',
          'maxDistance': 15.0,
        };

        // Build the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterBottomSheetWidget(
                availableCategories: testCategories,
                initialFilters: initialFilters,
                onApplyFilters: (_) {},
              ),
            ),
          ),
        );

        // Verify initial state
        expect(find.text('Filters'), findsOneWidget);
        expect(find.text('Minimum Rating'), findsOneWidget);
        expect(find.text('Categories'), findsOneWidget);
        expect(find.text('Sort By'), findsOneWidget);
        expect(find.text('Maximum Distance'), findsOneWidget);

        // Check that initial values are set correctly
        expect(find.widgetWithText(Chip, 'Plumbing'), findsOneWidget);
        expect(find.widgetWithText(Chip, 'Distance'), findsOneWidget);

        // Verify the chip for Plumbing has the selected color (primaryColor background)
        final plumbingChip = tester.widget<Chip>(find.widgetWithText(Chip, 'Plumbing'));
        expect((plumbingChip.backgroundColor as Color), isNot(Colors.grey.shade200));

        // Verify the slider for rating is at 3.5
        final ratingSlider = tester.widget<Slider>(find.byType(Slider).first);
        expect(ratingSlider.value, 3.5);
      });

  testWidgets('FilterBottomSheetWidget allows changing filter values',
          (WidgetTester tester) async {
        bool filtersApplied = false;
        Map<String, dynamic>? appliedFilters;

        // Build the widget with no initial filters
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterBottomSheetWidget(
                availableCategories: testCategories,
                initialFilters: null,
                onApplyFilters: (filters) {
                  filtersApplied = true;
                  appliedFilters = filters;
                },
              ),
            ),
          ),
        );

        // Change rating by moving the slider
        final ratingSlider = find.byType(Slider).first;
        await tester.drag(ratingSlider, const Offset(20.0, 0.0));
        await tester.pump();

        // Select a category
        await tester.tap(find.widgetWithText(Chip, 'Electrical'));
        await tester.pump();

        // Change sort option
        await tester.tap(find.widgetWithText(Chip, 'Price: Low to High'));
        await tester.pump();

        // Tap Apply Filters button
        await tester.tap(find.text('Apply Filters'));
        await tester.pump();

        // Verify callback was called with correct filters
        expect(filtersApplied, true);
        expect(appliedFilters?['categories'], contains('Electrical'));
        expect(appliedFilters?['sortBy'], 'Price: Low to High');
        expect(appliedFilters?['minRating'], isNot(0.0)); // Should have changed from default
      });

  testWidgets('FilterBottomSheetWidget can select multiple categories',
          (WidgetTester tester) async {
        Map<String, dynamic>? appliedFilters;

        // Build the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterBottomSheetWidget(
                availableCategories: testCategories,
                initialFilters: null,
                onApplyFilters: (filters) {
                  appliedFilters = filters;
                },
              ),
            ),
          ),
        );

        // Select multiple categories
        await tester.tap(find.widgetWithText(Chip, 'Plumbing'));
        await tester.pump();
        await tester.tap(find.widgetWithText(Chip, 'Electrical'));
        await tester.pump();

        // Apply filters
        await tester.tap(find.text('Apply Filters'));
        await tester.pump();

        // Verify multiple categories were selected
        expect(appliedFilters?['categories'], contains('Plumbing'));
        expect(appliedFilters?['categories'], contains('Electrical'));
        expect((appliedFilters?['categories'] as List).length, 2);
      });

  testWidgets('FilterBottomSheetWidget can toggle selected categories',
          (WidgetTester tester) async {
        // Setup initial filters with a category already selected
        final initialFilters = {
          'categories': ['Plumbing'],
          'sortBy': 'Rating',
          'minRating': 0.0,
          'maxDistance': 10.0,
        };

        Map<String, dynamic>? appliedFilters;

        // Build the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterBottomSheetWidget(
                availableCategories: testCategories,
                initialFilters: initialFilters,
                onApplyFilters: (filters) {
                  appliedFilters = filters;
                },
              ),
            ),
          ),
        );

        // Verify Plumbing is initially selected
        final plumbingChipBefore = tester.widget<Chip>(find.widgetWithText(Chip, 'Plumbing'));
        expect((plumbingChipBefore.backgroundColor as Color), isNot(Colors.grey.shade200));

        // Deselect Plumbing by tapping it
        await tester.tap(find.widgetWithText(Chip, 'Plumbing'));
        await tester.pump();

        // Apply filters
        await tester.tap(find.text('Apply Filters'));
        await tester.pump();

        // Verify Plumbing was deselected
        expect((appliedFilters?['categories'] as List).isEmpty, true);
      });

  testWidgets('FilterBottomSheetWidget closes when close button is pressed',
          (WidgetTester tester) async {
        bool filtersClosed = false;

        // Build the widget directly
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => FilterBottomSheetWidget(
                            availableCategories: testCategories,
                            onApplyFilters: (_) {},
                          ),
                        ).then((_) {
                          filtersClosed = true;
                        });
                      },
                      child: const Text('Open Filters'),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Open the filter bottom sheet
        await tester.tap(find.text('Open Filters'));
        await tester.pumpAndSettle();

        // Verify the sheet is shown
        expect(find.text('Filters'), findsOneWidget);

        // Tap the close button (X icon)
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        // Verify bottom sheet was closed
        expect(find.text('Filters'), findsNothing);
        expect(filtersClosed, true);
      });
}