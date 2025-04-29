import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/location/views/location_list_view.dart';
import 'package:sohojogi/screens/location/view_model/location_view_model.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late LocationViewModel viewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    viewModel = LocationViewModel();
  });

  group('LocationListView Tests', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for basic UI elements
      expect(find.text('Select Location'), findsOneWidget);
      expect(find.text('Add New Location'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Use current location'), findsOneWidget);
      expect(find.text('Choose on map'), findsOneWidget);
    });

    testWidgets('shows empty state when no locations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No saved locations'), findsOneWidget);
      expect(find.text('Add a new location or use your current location'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (WidgetTester tester) async {
      viewModel.setLoadingState(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationListView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

  });
}