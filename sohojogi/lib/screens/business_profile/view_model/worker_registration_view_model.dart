import 'package:flutter/material.dart';
import '../../../base/services/worker_registration_service.dart';
import '../models/worker_registration_model.dart';

class WorkerRegistrationViewModel extends ChangeNotifier {
  final WorkerRegistrationModel _registrationData = WorkerRegistrationModel();
  final WorkerRegistrationService _service = WorkerRegistrationService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _registrationSuccess = false;
  bool _isInitialized = false;

  // Work types and countries
  List<WorkTypeModel> _workTypes = [];
  List<CountryModel> _countries = [];

  // Getters
  WorkerRegistrationModel get registrationData => _registrationData;
  List<WorkTypeModel> get workTypes => _workTypes;
  List<CountryModel> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get registrationSuccess => _registrationSuccess;
  bool get isFormValid => _registrationData.isValid;

  // Initialize data from Supabase
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load work types and countries from Supabase
      final workTypesData = await _service.getWorkTypes();
      final countriesData = await _service.getCountries();

      _workTypes = workTypesData;
      _countries = countriesData;
      _isInitialized = true;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load data. Please try again.';
      notifyListeners();
    }
  }

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
    for (var country in _countries) {
      country.isSelected = false;
    }

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
      // Submit to Supabase
      await _service.registerWorker(_registrationData);

      _isLoading = false;
      _registrationSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
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