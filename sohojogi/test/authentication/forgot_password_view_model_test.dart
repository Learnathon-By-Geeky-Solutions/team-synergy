import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/forgot_password_view_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late ForgotPasswordViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = ForgotPasswordViewModel(authService: mockAuthService);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('ForgotPasswordViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('Send password reset email with empty email', () async {
      viewModel.emailController.text = '';
      expect(await viewModel.sendPasswordResetEmail(), false);
      expect(viewModel.errorMessage, 'Please enter your email');
    });

    test('Send password reset email with error', () async {
      viewModel.emailController.text = 'invalid@email.com';
      expect(await viewModel.sendPasswordResetEmail(), false);
      expect(viewModel.errorMessage, 'An unexpected error occurred. Please try again.');
    });
  });
}