import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  Future<bool> signup() async {
    if (!_validateInputs()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var user = {
        'phone_number': phoneController.text,
        'name': nameController.text,
        'password': passwordController.text
      };

      await Supabase.instance.client.from('user').insert(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty) {
      _errorMessage = 'Please enter your name';
      notifyListeners();
      return false;
    }

    if (phoneController.text.isEmpty) {
      _errorMessage = 'Please enter your phone number';
      notifyListeners();
      return false;
    }

    if (passwordController.text.isEmpty) {
      _errorMessage = 'Please enter a password';
      notifyListeners();
      return false;
    }

    if (!_termsAccepted) {
      _errorMessage = 'Please accept the terms of service';
      notifyListeners();
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}