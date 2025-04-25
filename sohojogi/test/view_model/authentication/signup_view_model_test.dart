import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sohojogi/screens/authentication/view_model/signup_view_model.dart';
import 'package:sohojogi/base/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late SignUpViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = SignUpViewModel(authService: mockAuthService);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('SignUpViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.obscurePassword, true);
      expect(viewModel.termsAccepted, false);
    });

    test('Toggle password visibility', () {
      viewModel.togglePasswordVisibility();
      expect(viewModel.obscurePassword, false);
    });

    test('Set terms accepted', () {
      viewModel.setTermsAccepted(true);
      expect(viewModel.termsAccepted, true);
    });

    test('Sign up with empty name', () async {
      viewModel.nameController.text = '';
      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = 'password123';
      viewModel.setTermsAccepted(true);

      expect(await viewModel.signup(), false);
      expect(viewModel.errorMessage, 'Please enter your name');
    });

    test('Sign up with empty email', () async {
      viewModel.nameController.text = 'Test User';
      viewModel.emailController.text = '';
      viewModel.passwordController.text = 'password123';
      viewModel.setTermsAccepted(true);

      expect(await viewModel.signup(), false);
      expect(viewModel.errorMessage, 'Please enter your email');
    });

    test('Sign up with empty password', () async {
      viewModel.nameController.text = 'Test User';
      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = '';
      viewModel.setTermsAccepted(true);

      expect(await viewModel.signup(), false);
      expect(viewModel.errorMessage, 'Please enter your password');
    });

    test('Sign up without accepting terms', () async {
      viewModel.nameController.text = 'Test User';
      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = 'password123';
      viewModel.setTermsAccepted(false);

      expect(await viewModel.signup(), false);
      expect(viewModel.errorMessage, 'You must accept the terms and conditions');
    });

    test('Sign up with invalid inputs', () async {
      viewModel.nameController.text = '';
      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = 'password123';
      viewModel.setTermsAccepted(true);

      expect(await viewModel.signup(), false);
      expect(viewModel.errorMessage, 'Please enter your name');
    });
  });
}