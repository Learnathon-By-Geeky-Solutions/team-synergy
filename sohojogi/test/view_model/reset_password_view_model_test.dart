import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/view_model/reset_password_view_model.dart';

void main() {
  late ResetPasswordViewModel viewModel;

  setUp(() {
    viewModel = ResetPasswordViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('ResetPasswordViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.obscureNewPassword, true);
      expect(viewModel.obscureConfirmPassword, true);
    });

    test('Toggle password visibility', () {
      expect(viewModel.obscureNewPassword, true);
      viewModel.toggleNewPasswordVisibility();
      expect(viewModel.obscureNewPassword, false);

      expect(viewModel.obscureConfirmPassword, true);
      viewModel.toggleConfirmPasswordVisibility();
      expect(viewModel.obscureConfirmPassword, false);
    });

    test('Validate inputs - passwords do not match', () async {
      viewModel.newPasswordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password456';
      expect(await viewModel.resetPassword(), false);
      expect(viewModel.errorMessage, 'Passwords do not match');
    });

    test('Reset password with valid inputs', () async {
      viewModel.newPasswordController.text = 'password123';
      viewModel.confirmPasswordController.text = 'password123';
      expect(await viewModel.resetPassword(), true); // Mock AuthService success
    });
  });
}