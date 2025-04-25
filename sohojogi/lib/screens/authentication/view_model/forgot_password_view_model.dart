import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class ForgotPasswordViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();

  Future<bool> sendPasswordResetEmail() async {
    if (!validateField(emailController.text, 'email')) {
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      final error = await _authService.sendPasswordResetEmail(emailController.text);
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}