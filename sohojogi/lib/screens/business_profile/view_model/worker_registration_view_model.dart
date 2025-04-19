// lib/screens/business_profile/view_model/worker_registration_view_model.dart
import 'package:flutter/material.dart';
import '../models/worker_registration_model.dart';

class WorkerRegistrationViewModel extends ChangeNotifier {
  final WorkerRegistrationModel _registrationData = WorkerRegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;
  bool _registrationSuccess = false;

  // Available work types

  final List<WorkTypeModel> _workTypes = [
    WorkTypeModel(id: '1', name: 'Plumber', icon: 'assets/icons/plumber.png'),
    WorkTypeModel(id: '2', name: 'Cleaning', icon: 'assets/icons/cleaning.png'),
    WorkTypeModel(id: '3', name: 'Carpenter', icon: 'assets/icons/carpenter.png'),
    WorkTypeModel(id: '4', name: 'Electrician', icon: 'assets/icons/electrician.png'),
    WorkTypeModel(id: '5', name: 'Painter', icon: 'assets/icons/painter.png'),
    WorkTypeModel(id: '6', name: 'AC Technician', icon: 'assets/icons/ac_technician.png'),
    WorkTypeModel(id: '7', name: 'Gardener', icon: 'assets/icons/gardener.png'),
    WorkTypeModel(id: '8', name: 'Driver', icon: 'assets/icons/driver.png'),
  ];

  // Available countries
  final List<CountryModel> _countries = [
    CountryModel(id: '1', name: 'Pakistan', flag: '🇵🇰'),
    CountryModel(id: '2', name: 'UAE', flag: '🇦🇪'),
    CountryModel(id: '3', name: 'Gulf', flag: '🇸🇦'),
    CountryModel(id: '4', name: 'India', flag: '🇮🇳'),
    CountryModel(id: '5', name: 'Bangladesh', flag: '🇧🇩'),
  ];

  // Getters
  WorkerRegistrationModel get registrationData => _registrationData;
  List<WorkTypeModel> get workTypes => _workTypes;
  List<CountryModel> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get registrationSuccess => _registrationSuccess;
  bool get isFormValid => _registrationData.isValid;

  // Update methods
  void updateFullName(String value) {
    _registrationData.fullName = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _registrationData.phoneNumber = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _registrationData.email = value;
    notifyListeners();
  }

  void updateYearsOfExperience(int value) {
    _registrationData.yearsOfExperience = value;
    notifyListeners();
  }

  void toggleWorkType(String id) {
    final index = _workTypes.indexWhere((type) => type.id == id);
    if (index != -1) {
      _workTypes[index].isSelected = !_workTypes[index].isSelected;

      // Update the selected work types in registration data
      _registrationData.selectedWorkTypes = _workTypes
          .where((type) => type.isSelected)
          .toList();

      notifyListeners();
    }
  }

  void toggleCountry(String id) {
    // First unselect all countries
    for (var country in _countries) {
      country.isSelected = false;
    }

    // Then select the chosen one
    final index = _countries.indexWhere((country) => country.id == id);
    if (index != -1) {
      _countries[index].isSelected = true;
      _registrationData.experienceCountry = _countries[index].name;
      notifyListeners();
    }
  }

  String getSelectedWorkTypesText() {
    final selectedTypes = _workTypes.where((type) => type.isSelected).toList();
    if (selectedTypes.isEmpty) {
      return 'e.g. Plumber, Electrician etc';
    } else if (selectedTypes.length == 1) {
      return selectedTypes.first.name;
    } else {
      return '${selectedTypes.first.name} +${selectedTypes.length - 1} more';
    }
  }

  String getSelectedCountryText() {
    final selectedCountry = _countries.firstWhere(
          (country) => country.isSelected,
      orElse: () => CountryModel(id: '', name: 'Select Country', flag: ''),
    );

    return selectedCountry.id.isEmpty ? 'Select Country' : selectedCountry.name;
  }

  Future<bool> submitRegistration() async {
    if (!_registrationData.isValid) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would submit to an API here
      // final response = await apiService.registerWorker(_registrationData);

      _isLoading = false;
      _registrationSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    _registrationData.fullName = '';
    _registrationData.phoneNumber = '';
    _registrationData.email = '';
    _registrationData.yearsOfExperience = 0;
    _registrationData.experienceCountry = '';

    for (var workType in _workTypes) {
      workType.isSelected = false;
    }

    for (var country in _countries) {
      country.isSelected = false;
    }

    _registrationData.selectedWorkTypes = [];
    _errorMessage = null;
    _registrationSuccess = false;

    notifyListeners();
  }

}