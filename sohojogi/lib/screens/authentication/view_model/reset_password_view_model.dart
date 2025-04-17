import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscureNewPassword = true;
  bool get obscureNewPassword => _obscureNewPassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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
      _errorMessage = 'Please enter a new password';
      notifyListeners();
      return false;
    }

    if (newPasswordController.text.length < 8) {
      _errorMessage = 'Password must be at least 8 characters long';
      notifyListeners();
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.resetPassword(
        phoneNumber: '',
        newPassword: newPasswordController.text,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to reset password';
      notifyListeners();
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
