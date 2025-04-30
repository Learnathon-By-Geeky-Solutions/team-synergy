import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/service_searched/view_model/service_searched_view_model.dart';
import 'package:sohojogi/screens/service_searched/views/service_searched_list_view.dart';
import 'package:sohojogi/screens/service_searched/widgets/search_header_widget.dart';
import 'package:sohojogi/screens/service_searched/widgets/service_provider_card_widget.dart';

class MockServiceSearchedViewModel extends Mock implements ServiceSearchedViewModel {
  final List<ServiceProviderModel> _providers = [];
  final List<String> _categories = ['Plumbing', 'Electrical', 'Cleaning'];
  bool _loading = false;
  String _error = '';
  Map<String, dynamic>? _filters;

  @override
  List<ServiceProviderModel> get serviceProviders => _providers;

  @override
  List<String> get availableCategories => _categories;

  @override
  bool get isLoading => _loading;

  @override
  String get errorMessage => _error;

  @override
  Map<String, dynamic>? get currentFilters => _filters;

  get hasError => null;

  void setProviders(List<ServiceProviderModel> providers) {
    _providers.clear();
    _providers.addAll(providers);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void setFilters(Map<String, dynamic>? filters) {
    _filters = filters;
    notifyListeners();
  }

  @override
  Future<void> searchServiceProviders({
    required String searchQuery,
    required double userLatitude,
    required double userLongitude,
    Map<String, dynamic>? filters,
  }) async {
    // Mock implementation for testing
    _filters = filters;
    notifyListeners();
    return Future.value();
  }

  @override
  Future<void> applyFilters(
      Map<String, dynamic> filters,
      String searchQuery,
      double userLatitude,
      double userLongitude,
      ) async {
    _filters = filters;
    notifyListeners();
    return Future.value();
  }

  @override
  Future<void> init() async {
    return Future.value();
  }

  @override
  void notifyListeners() {}
}

void main() {
  late MockServiceSearchedViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockServiceSearchedViewModel();
  });

  // Sample service providers for testing
  final sampleProviders = [
    ServiceProviderModel(
      id: '1',
      name: 'John Doe',
      profileImage: 'https://example.com/john.jpg',
      location: 'Dhaka',
      latitude: 23.8103,
      longitude: 90.4125,
      serviceCategory: 'Plumbing',
      email: 'john@example.com',
      phoneNumber: '1234567890',
      gender: Gender.male,
      rating: 4.5,
      reviewCount: 10,
    ),
    ServiceProviderModel(
      id: '2',
      name: 'Jane Smith',
      profileImage: 'https://example.com/jane.jpg',
      location: 'Chittagong',
      latitude: 22.3569,
      longitude: 91.7832,
      serviceCategory: 'Electrical',
      email: 'jane@example.com',
      phoneNumber: '0987654321',
      gender: Gender.female,
      rating: 5.0,
      reviewCount: 15,
    ),
  ];

  Widget buildTestWidget({bool darkMode = false}) {
    return MaterialApp(
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: MediaQuery(
        data: MediaQueryData(
          platformBrightness: darkMode ? Brightness.dark : Brightness.light,
        ),
        child: ChangeNotifierProvider<ServiceSearchedViewModel>.value(
          value: mockViewModel,
          child: const ServiceSearchedListView(
            searchQuery: 'plumber',
            latitude: 23.8103,
            longitude: 90.4125,
            location: 'Dhaka, Bangladesh',
          ),
        ),
      ),
    );
  }

  group('ServiceSearchedListView UI Tests', () {
    testWidgets('should display search header with correct information',
            (WidgetTester tester) async {
          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(buildTestWidget());

            // Check if search header appears with correct data
            expect(find.byType(SearchHeaderWidget), findsOneWidget);
            expect(find.text('plumber'), findsAtLeastNWidgets(1));
            expect(find.text('Dhaka, Bangladesh'), findsOneWidget);
            expect(find.text('Showing results for "plumber"'), findsOneWidget);
          });
        });

    testWidgets('should display loading indicator when loading',
            (WidgetTester tester) async {
          mockViewModel.setLoading(true);
          mockViewModel.setProviders([]);

          await tester.pumpWidget(buildTestWidget());

          // Verify loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(ServiceProviderCardWidget), findsNothing);
        });

    testWidgets('should display error message when error occurs',
            (WidgetTester tester) async {
          mockViewModel.setLoading(false);
          mockViewModel.setError('Failed to load service providers');
          mockViewModel.setProviders([]);

          await tester.pumpWidget(buildTestWidget());

          // Verify error message is displayed
          expect(find.text('Failed to load service providers'), findsOneWidget);
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('Retry'), findsOneWidget);
        });

    testWidgets('should display empty state when no providers found',
            (WidgetTester tester) async {
          mockViewModel.setLoading(false);
          mockViewModel.setError('');
          mockViewModel.setProviders([]);

          await tester.pumpWidget(buildTestWidget());

          // Verify empty state is displayed
          expect(find.text('No service providers found'), findsOneWidget);
          expect(find.text('Try adjusting your search or filters'), findsOneWidget);
          expect(find.byIcon(Icons.search_off), findsOneWidget);
        });

    testWidgets('should display list of service providers when available',
            (WidgetTester tester) async {
          mockViewModel.setLoading(false);
          mockViewModel.setError('');
          mockViewModel.setProviders(sampleProviders);

          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(buildTestWidget());

            // Verify provider cards are displayed
            expect(find.byType(ServiceProviderCardWidget), findsNWidgets(2));
            expect(find.text('John Doe'), findsOneWidget);
            expect(find.text('Jane Smith'), findsOneWidget);
          });
        });

    testWidgets('should adapt to dark mode properly',
            (WidgetTester tester) async {
          mockViewModel.setProviders(sampleProviders);

          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(buildTestWidget(darkMode: true));

            // Verify dark mode colors are applied
            final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
            expect(scaffold.backgroundColor, grayColor);
          });
        });
  });

  group('ServiceSearchedListView Interaction Tests', () {

    testWidgets('should show bottom sheet menu when card menu is tapped',
            (WidgetTester tester) async {
          mockViewModel.setProviders(sampleProviders);

          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(buildTestWidget());

            // Find and tap menu icon on first provider card
            await tester.tap(find.byIcon(Icons.more_vert).first);
            await tester.pumpAndSettle();

            // Verify bottom sheet options are displayed
            expect(find.text('Save to Bookmarks'), findsOneWidget);
            expect(find.text('Block This Provider'), findsOneWidget);
            expect(find.text('Report Provider'), findsOneWidget);
          });
        });
  });

  group('Navigation and AppBar Tests', () {
    testWidgets('should display AppNavBar at bottom',
            (WidgetTester tester) async {
          await tester.pumpWidget(buildTestWidget());

          // Verify bottom navigation bar is present
          expect(find.byType(AppNavBar), findsOneWidget);
        });

    testWidgets('should navigate back when back button is pressed',
            (WidgetTester tester) async {

          await tester.pumpWidget(MaterialApp(
            home: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider<ServiceSearchedViewModel>.value(
                              value: mockViewModel,
                              child: const ServiceSearchedListView(
                                searchQuery: 'plumber',
                                latitude: 23.8103,
                                longitude: 90.4125,
                                location: 'Dhaka, Bangladesh',
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Go to search'),
                    ),
                  ),
                );
              },
            ),
          ));

          // Navigate to search screen
          await tester.tap(find.text('Go to search'));
          await tester.pumpAndSettle();

          // Tap back button
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          // Should be back at first screen
          expect(find.text('Go to search'), findsOneWidget);
        });
  });
}