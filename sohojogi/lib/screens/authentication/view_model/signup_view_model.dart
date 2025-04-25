import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class SignUpViewModel extends BaseAuthViewModel {
  final AuthService _authService;

  SignUpViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

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

    setLoading(true);
    setErrorMessage(null);

    try {
      final error = await _authService.signUp(
        email: emailController.text,
        password: passwordController.text,
        displayName: nameController.text,
      );

      if (error != null) {
        setErrorMessage(error);
        setLoading(false);
        return false;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      setErrorMessage('An unexpected error occurred. Please try again.');
      return false;
    }
  }

  bool _validateInputs() {
    if (!validateField(nameController.text, 'name')) {
      return false;
    }

    if (!validateField(emailController.text, 'email')) {
      return false;
    }

    if (!validateField(passwordController.text, 'password')) {
      return false;
    }

    if (!_termsAccepted) {
      setErrorMessage('You must accept the terms and conditions');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}