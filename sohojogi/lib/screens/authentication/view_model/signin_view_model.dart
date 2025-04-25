import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class SignInViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> signIn() async {
    if (!_validateInputs()) {
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      final error = await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
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
    if (!validateField(emailController.text, 'email')) {
      return false;
    }

    if (!validateField(passwordController.text, 'password')) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}