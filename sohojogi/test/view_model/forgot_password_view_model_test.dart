import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/view_model/forgot_password_view_model.dart';

void main() {
  group('ForgotPasswordViewModel', () {
    late ForgotPasswordViewModel viewModel;

    setUp(() {
      viewModel = ForgotPasswordViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('Validate phone number - empty input', () async {
      viewModel.phoneController.text = '';
      final result = await viewModel.sendOTP();
      expect(result, false);
      expect(viewModel.errorMessage, 'Please enter your phone number');
    });

    test('Send OTP successfully', () async {
      viewModel.phoneController.text = '1234567890';
      final result = await viewModel.sendOTP();
      expect(result, true); // Mock success in AuthService
    });
  });
}