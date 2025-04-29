import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/business_profile/view_model/worker_registration_view_model.dart';
import 'package:sohojogi/screens/business_profile/views/business_profile_list_view.dart';
import 'package:sohojogi/screens/business_profile/models/worker_registration_model.dart';

// Simple mock of WorkerRegistrationViewModel for testing
class MockWorkerRegistrationViewModel extends ChangeNotifier implements WorkerRegistrationViewModel {
  final WorkerRegistrationModel _registrationData = WorkerRegistrationModel();
  final List<WorkTypeModel> _workTypes = [];
  final List<CountryModel> _countries = [];
  bool _isLoading = false;
  String? _errorMessage;
  final bool _registrationSuccess = false;

  @override
  WorkerRegistrationModel get registrationData => _registrationData;

  @override
  List<WorkTypeModel> get workTypes => _workTypes;

  @override
  List<CountryModel> get countries => _countries;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get registrationSuccess => _registrationSuccess;

  @override
  bool get isFormValid => _registrationData.isValid;

  // Mock data tracking
  String updatedName = '';
  String updatedPhone = '';
  String updatedEmail = '';
  int updatedYears = 0;
  String toggledWorkTypeId = '';
  String toggledCountryId = '';
  bool submitCalled = false;
  bool initializeCalled = false;

  @override
  void updateFullName(String value) {
    updatedName = value;
    _registrationData.fullName = value;
    notifyListeners();
  }

  @override
  void updatePhoneNumber(String value) {
    updatedPhone = value;
    _registrationData.phoneNumber = value;
    notifyListeners();
  }

  @override
  void updateEmail(String value) {
    updatedEmail = value;
    _registrationData.email = value;
    notifyListeners();
  }

  @override
  void updateYearsOfExperience(int value) {
    updatedYears = value;
    _registrationData.yearsOfExperience = value;
    notifyListeners();
  }

  @override
  void toggleWorkType(String id) {
    toggledWorkTypeId = id;
    notifyListeners();
  }

  @override
  void toggleCountry(String id) {
    toggledCountryId = id;
    notifyListeners();
  }

  @override
  String getSelectedWorkTypesText() {
    return 'e.g. Plumber, Electrician etc';
  }

  @override
  String getSelectedCountryText() {
    return 'Select Country';
  }

  @override
  Future<bool> submitRegistration() async {
    submitCalled = true;
    return true;
  }

  @override
  Future<void> initialize() async {
    initializeCalled = true;
  }

  @override
  void resetForm() {}

  // Test helper methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void addWorkType(WorkTypeModel workType) {
    _workTypes.add(workType);
    notifyListeners();
  }

  void addCountry(CountryModel country) {
    _countries.add(country);
    notifyListeners();
  }
}

void main() {
  group('BusinessProfileListView', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      bool backPressed = false;
      final mockViewModel = MockWorkerRegistrationViewModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {
                backPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify app bar title
      expect(find.text('Become A Worker'), findsOneWidget);

      // Verify form section titles
      expect(find.text('Worker Registration'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Work Type'), findsOneWidget);
      expect(find.text('Years of Experience'), findsOneWidget);
      expect(find.text('Experience Country'), findsOneWidget);

      // Verify submit button and benefits link
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Learn about worker benefits'), findsOneWidget);

      // Verify back button works
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      expect(backPressed, true);

      // Verify initialize was called
      expect(mockViewModel.initializeCalled, true);
    });

    testWidgets('shows error messages on submit with empty fields', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();

      // Set a larger surface size for testing
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Make sure the submit button is visible before tapping
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Check for field validation errors (these may be shown differently in the actual implementation)
      expect(find.text('Please enter your full name'), findsOneWidget);
      // Check other validation errors as needed
    });

    testWidgets('updates view model when text fields change', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Enter text in the name field
      await tester.enterText(find.widgetWithText(TextField, 'Enter your full name'), 'John Doe');
      expect(mockViewModel.updatedName, 'John Doe');

      // Enter text in the phone field
      await tester.enterText(find.widgetWithText(TextField, 'Enter your phone number'), '1234567890');
      expect(mockViewModel.updatedPhone, '1234567890');

      // Enter text in the email field
      await tester.enterText(find.widgetWithText(TextField, 'Enter your email address'), 'john@example.com');
      expect(mockViewModel.updatedEmail, 'john@example.com');

      // Enter text in the years field
      await tester.enterText(find.widgetWithText(TextField, 'Enter years of experience'), '5');
      expect(mockViewModel.updatedYears, 5);
    });

    testWidgets('shows loading indicator when loading', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();
      mockViewModel.setLoading(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message from view model', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();
      mockViewModel.setErrorMessage('Registration failed');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Verify error message is displayed
      expect(find.text('Registration failed'), findsOneWidget);
    });

    testWidgets('shows work type selection modal', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();
      mockViewModel.addWorkType(
          WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path')
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Tap on work type field to open modal
      await tester.tap(find.text('e.g. Plumber, Electrician etc'));
      await tester.pumpAndSettle();

      // Verify modal title appears
      expect(find.text('Select work type'), findsOneWidget);
    });

    testWidgets('shows country selection modal', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();
      mockViewModel.addCountry(
          CountryModel(id: '1', name: 'United States', flag: '🇺🇸')
      );

      // Set a larger surface size for testing
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Make sure the country field is visible before tapping
      await tester.ensureVisible(find.text('Select Country'));
      await tester.tap(find.text('Select Country'));
      await tester.pumpAndSettle(); // Wait for modal to appear

      // Verify the modal appears with its title
      expect(find.text('Select country'), findsOneWidget);
    });

    testWidgets('navigates to benefits page when link is tapped', (WidgetTester tester) async {
      final mockViewModel = MockWorkerRegistrationViewModel();

      // Set a larger surface size for testing
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkerRegistrationViewModel>.value(
            value: mockViewModel,
            child: BusinessProfileListView(
              onBackPressed: () {},
            ),
          ),
        ),
      );

      // Make sure the benefits link is visible before tapping
      await tester.ensureVisible(find.text('Learn about worker benefits'));
      await tester.tap(find.text('Learn about worker benefits'));
      await tester.pumpAndSettle(); // Wait for navigation

      // Verify navigation to benefits page
      expect(find.text('Worker Benefits'), findsOneWidget);
    });
  });
}