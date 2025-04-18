import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/authentication/view_model/signup_view_model.dart';

void main() {
  late SignUpViewModel viewModel;

  setUp(() {
    viewModel = SignUpViewModel();
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
      expect(viewModel.obscurePassword, true);
      viewModel.togglePasswordVisibility();
      expect(viewModel.obscurePassword, false);
    });

    test('Set terms accepted', () {
      expect(viewModel.termsAccepted, false);
      viewModel.setTermsAccepted(true);
      expect(viewModel.termsAccepted, true);
    });
  });
}