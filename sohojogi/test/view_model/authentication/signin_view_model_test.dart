import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/screens/authentication/view_model/signin_view_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late SignInViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = SignInViewModel(authService: mockAuthService);
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
      viewModel.togglePasswordVisibility();
      expect(viewModel.obscurePassword, false);
    });

    test('Sign in with empty email', () async {
      viewModel.emailController.text = '';
      viewModel.passwordController.text = 'password123';

      expect(await viewModel.signIn(), false);
      expect(viewModel.errorMessage, 'Please enter your email');
    });

    test('Sign in with empty password', () async {
      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = '';

      expect(await viewModel.signIn(), false);
      expect(viewModel.errorMessage, 'Please enter your password');
    });
  });
}