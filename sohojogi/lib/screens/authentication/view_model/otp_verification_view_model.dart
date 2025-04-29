import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class OTPVerificationViewModel extends BaseAuthViewModel {

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
      setLoading(false);
      return true;
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
      setLoading(false);
      setErrorMessage('OTP resent successfully');
    } catch (e) {
      setLoading(false);
      setErrorMessage('Failed to resend OTP');
    }
  }
}