import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class OTPVerificationViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();

  String phoneNumber = '';
  String otpCode = '';

  Future<bool> verifyOTP() async {
    if (otpCode.isEmpty || otpCode.length < 6) {
      setErrorMessage('Please enter a valid OTP');
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      final success = await _authService.verifyOTP(
        phoneNumber: phoneNumber,
        otp: otpCode,
      );
      setLoading(false);
      return success;
    } catch (e) {
      setLoading(false);
      setErrorMessage('Invalid OTP');
      return false;
    }
  }

  Future<void> resendOTP() async {
    setLoading(true);
    setErrorMessage(null);

    try {
      await _authService.sendOTP(phoneNumber);
      setLoading(false);
      setErrorMessage('OTP resent successfully');
    } catch (e) {
      setLoading(false);
      setErrorMessage('Failed to resend OTP');
    }
  }
}