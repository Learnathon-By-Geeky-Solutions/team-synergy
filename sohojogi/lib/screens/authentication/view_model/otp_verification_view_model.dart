import 'package:flutter/material.dart';
import 'package:sohojogi/base/services/auth_service.dart';

class OTPVerificationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String phoneNumber = ''; // Will be set from previous screen
  String otpCode = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOTP() async {
    if (otpCode.isEmpty || otpCode.length < 6) {
      _errorMessage = 'Please enter a valid OTP';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.verifyOTP(
        phoneNumber: phoneNumber,
        otp: otpCode,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid OTP';
      notifyListeners();
      return false;
    }
  }

  Future<void> resendOTP() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendOTP(phoneNumber);
      _isLoading = false;
      _errorMessage = 'OTP resent successfully';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to resend OTP';
      notifyListeners();
    }
  }
}
