import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class ForgotPasswordViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();
  final TextEditingController phoneController = TextEditingController();

  Future<bool> sendOTP() async {
    if (!validateField(phoneController.text, 'phone number')) {
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      final success = await _authService.sendOTP(phoneController.text);
      setLoading(false);
      return success;
    } catch (e) {
      setLoading(false);
      setErrorMessage('Failed to send OTP');
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}