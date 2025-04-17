import 'package:flutter/material.dart';

class BaseAuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Common validation methods
  bool validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      setErrorMessage('Please enter your $fieldName');
      return false;
    }
    return true;
  }
}