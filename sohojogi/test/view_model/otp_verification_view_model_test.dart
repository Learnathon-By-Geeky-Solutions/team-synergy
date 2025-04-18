import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/view_model/otp_verification_view_model.dart';

void main() {
  late OTPVerificationViewModel viewModel;

  setUp(() {
    viewModel = OTPVerificationViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('OTPVerificationViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.otpCode, '');
    });

    test('Validate OTP - invalid OTP', () async {
      viewModel.otpCode = '123';
      expect(await viewModel.verifyOTP(), false);
      expect(viewModel.errorMessage, 'Please enter a valid OTP');
    });

    test('Verify OTP with valid input', () async {
      viewModel.otpCode = '123456';
      expect(await viewModel.verifyOTP(), true); // Mock AuthService success
    });

    test('Resend OTP', () async {
      await viewModel.resendOTP();
      expect(viewModel.errorMessage, 'OTP resent successfully');
    });
  });
}