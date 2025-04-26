import 'package:flutter/material.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class ResetPasswordViewModel extends BaseAuthViewModel {
  //final AuthService _authService = AuthService();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool get obscureNewPassword => _obscureNewPassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void toggleNewPasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      setErrorMessage('Please enter a new password');
      return false;
    }

    if (newPasswordController.text.length < 8) {
      setErrorMessage('Password must be at least 8 characters long');
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      setErrorMessage('Passwords do not match');
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      setErrorMessage('Failed to reset password');
      return false;
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}