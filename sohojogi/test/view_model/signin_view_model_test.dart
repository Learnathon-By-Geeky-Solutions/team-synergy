import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/view_model/signin_view_model.dart';

void main() {
  late SignInViewModel viewModel;

  setUp(() {
    viewModel = SignInViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('SignInViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.obscurePassword, true);
    });

    test('Toggle password visibility', () {
      expect(viewModel.obscurePassword, true);
      viewModel.togglePasswordVisibility();
      expect(viewModel.obscurePassword, false);
    });

    test('Validate inputs - invalid phone number', () async {
      viewModel.phoneController.text = '';
      viewModel.passwordController.text = 'password123';
      expect(await viewModel.signIn(), false);
      expect(viewModel.errorMessage, 'Please enter your phone number');
    });

    test('Validate inputs - invalid password', () async {
      viewModel.phoneController.text = '1234567890';
      viewModel.passwordController.text = '';
      expect(await viewModel.signIn(), false);
      expect(viewModel.errorMessage, 'Please enter your password');
    });

    test('Sign in with valid inputs', () async {
      viewModel.phoneController.text = '1234567890';
      viewModel.passwordController.text = 'password123';
      expect(await viewModel.signIn(), false);
    });
  });
}