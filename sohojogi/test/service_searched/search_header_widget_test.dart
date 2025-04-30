import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/widgets/search_header_widget.dart';

void main() {
  late TextEditingController searchController;

  setUp(() {
    searchController = TextEditingController(text: 'plumber');
  });

  tearDown(() {
    searchController.dispose();
  });

  testWidgets('SearchHeaderWidget displays all UI elements correctly', (WidgetTester tester) async {
    // Arrange
    bool filterTapped = false;
    bool backTapped = false;
    bool locationTapped = false;
    String searchSubmitted = '';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHeaderWidget(
            searchQuery: 'plumber',
            currentLocation: 'Dhaka, Bangladesh',
            onFilterTap: () => filterTapped = true,
            onBackTap: () => backTapped = true,
            onLocationTap: () => locationTapped = true,
            searchController: searchController,
            onSearchSubmitted: (query) => searchSubmitted = query,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('plumber'), findsOneWidget);
    expect(find.text('Dhaka, Bangladesh'), findsOneWidget);
    expect(find.text('Showing results for "plumber"'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('SearchHeaderWidget triggers callbacks when buttons are tapped', (WidgetTester tester) async {
    // Arrange
    bool filterTapped = false;
    bool backTapped = false;
    bool locationTapped = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHeaderWidget(
            searchQuery: 'plumber',
            currentLocation: 'Dhaka, Bangladesh',
            onFilterTap: () => filterTapped = true,
            onBackTap: () => backTapped = true,
            onLocationTap: () => locationTapped = true,
            searchController: searchController,
            onSearchSubmitted: (_) {},
          ),
        ),
      ),
    );

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(backTapped, true);

    // Tap the filter button
    await tester.tap(find.byIcon(Icons.filter_list));
    expect(filterTapped, true);

    // Tap the location row
    await tester.tap(find.byIcon(Icons.location_on));
    expect(locationTapped, true);
  });

  testWidgets('SearchHeaderWidget submits search query when entered', (WidgetTester tester) async {
    // Arrange
    String submittedQuery = '';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHeaderWidget(
            searchQuery: 'plumber',
            currentLocation: 'Dhaka, Bangladesh',
            onFilterTap: () {},
            onBackTap: () {},
            onLocationTap: () {},
            searchController: searchController,
            onSearchSubmitted: (query) => submittedQuery = query,
          ),
        ),
      ),
    );

    // Clear the existing text and type a new query
    await tester.enterText(find.byType(TextField), 'electrician');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Assert
    expect(submittedQuery, 'electrician');
  });

  testWidgets('SearchHeaderWidget shows correct colors in dark mode', (WidgetTester tester) async {
    // Create a MediaQuery that simulates dark mode
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: SearchHeaderWidget(
              searchQuery: 'plumber',
              currentLocation: 'Dhaka, Bangladesh',
              onFilterTap: () {},
              onBackTap: () {},
              onLocationTap: () {},
              searchController: searchController,
              onSearchSubmitted: (_) {},
            ),
          ),
        ),
      ),
    );

    // Verify the container background color matches dark mode color
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, equals(darkColor));
  });

  testWidgets('SearchHeaderWidget shows correct colors in light mode', (WidgetTester tester) async {
    // Create a MediaQuery that simulates light mode
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.light),
            child: SearchHeaderWidget(
              searchQuery: 'plumber',
              currentLocation: 'Dhaka, Bangladesh',
              onFilterTap: () {},
              onBackTap: () {},
              onLocationTap: () {},
              searchController: searchController,
              onSearchSubmitted: (_) {},
            ),
          ),
        ),
      ),
    );

    // Verify the container background color matches light mode color
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, equals(lightColor));
  });

  testWidgets('SearchHeaderWidget allows long location text to be truncated', (WidgetTester tester) async {
    // Test with a very long location string
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHeaderWidget(
            searchQuery: 'plumber',
            currentLocation: 'A very long location name that should be truncated when displayed in the UI',
            onFilterTap: () {},
            onBackTap: () {},
            onLocationTap: () {},
            searchController: searchController,
            onSearchSubmitted: (_) {},
          ),
        ),
      ),
    );

    // Find the Text widget for location
    final locationText = tester.widget<Text>(
        find.text('A very long location name that should be truncated when displayed in the UI')
    );

    // Verify it has overflow set to ellipsis
    expect(locationText.overflow, equals(TextOverflow.ellipsis));
  });
}