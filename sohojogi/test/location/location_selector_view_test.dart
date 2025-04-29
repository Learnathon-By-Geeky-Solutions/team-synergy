import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/location/views/location_selector_view.dart';
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

  group('LocationSelectorView Tests', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationSelectorView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for main UI elements
      expect(find.text('Select Location'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Confirm Location'), findsOneWidget);

      // Check for dropdown sections
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('Select Country'), findsOneWidget);

      // Check for street address field
      expect(find.text('Street Address'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows quick options correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationSelectorView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quick Options'), findsOneWidget);
      expect(find.text('Use Current Location'), findsOneWidget);
    });

    testWidgets('can save location with name and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationSelectorView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Toggle save location checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Check if location name field appears
      expect(find.text('Location Name'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Street address + name field

      // Check if icon selector appears
      expect(find.text('Icon'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.work), findsOneWidget);
    });

    testWidgets('shows loading state when fetching data', (WidgetTester tester) async {
      viewModel.setLoadingState(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationSelectorView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('confirm button is disabled without required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationViewModel>(
            create: (_) => viewModel,
            child: const LocationSelectorView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);
    });
  });
}