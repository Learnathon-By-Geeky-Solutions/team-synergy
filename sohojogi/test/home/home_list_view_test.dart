import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';
import 'package:sohojogi/screens/home/view_model/home_view_model.dart';
import 'package:sohojogi/screens/home/widgets/body_content.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/navigation/app_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() {
  late HomeViewModel mockViewModel;

  setUpAll(() async {
SharedPreferences.setMockInitialValues({});
await Supabase.initialize(
url: supabaseUrl,
anonKey: supabaseKey,
);
});

setUp(() {
  mockViewModel = HomeViewModel();
});

  testWidgets('HomeScreen should render with all required components', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HomeViewModel>.value(
          value: mockViewModel,
          child: const HomeScreen(),
        ),
      ),
    );

    // Assert
    expect(find.byType(AppAppBar), findsOneWidget);
    expect(find.byType(HomeBodyContent), findsOneWidget);
    expect(find.byType(AppNavBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
  });

  testWidgets('HomeScreen should have correct background color', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HomeViewModel>.value(
          value: mockViewModel,
          child: const HomeScreen(),
        ),
      ),
    );

    // Find the Scaffold widget
    final Scaffold scaffold = tester.widget(find.byType(Scaffold));

    // Assert
    expect(scaffold.backgroundColor, Colors.grey[100]);
  });

  testWidgets('HomeScreen should have correct bottom navigation index', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HomeViewModel>.value(
          value: mockViewModel,
          child: const HomeScreen(),
        ),
      ),
    );

    // Find the AppNavBar widget
    final AppNavBar navBar = tester.widget(find.byType(AppNavBar));

    // Assert
    expect(navBar.currentIndex, 1);
  });

  testWidgets('HomeScreen should create a new HomeViewModel instance', (WidgetTester tester) async {
    // This test verifies that HomeScreen creates a new ViewModel instance

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Assert - ensure a ChangeNotifierProvider is used
    expect(find.byType(ChangeNotifierProvider<HomeViewModel>), findsOneWidget);
  });
}