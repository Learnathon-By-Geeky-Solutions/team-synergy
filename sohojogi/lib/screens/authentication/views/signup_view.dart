import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/signup_view_model.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_screen_layout.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: const _SignUpViewContent(),
    );
  }
}

class _SignUpViewContent extends StatelessWidget {
  const _SignUpViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Sign Up',
      subtitle: 'Welcome to SOHOJOGI\nFill the details to create your account',
      bottomNavigationWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Do you have an account?',
            style: theme.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Sign In',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      children: [
        buildTextField(
          controller: viewModel.nameController,
          hintText: 'Name',
        ),
        const SizedBox(height: 16),
        buildTextField(
          controller: viewModel.phoneController,
          hintText: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        buildPasswordField(
          controller: viewModel.passwordController,
          obscurePassword: viewModel.obscurePassword,
          toggleVisibility: viewModel.togglePasswordVisibility,
        ),
        const SizedBox(height: 16),
        buildTermsAcceptance(
          termsAccepted: viewModel.termsAccepted,
          setTermsAccepted: viewModel.setTermsAccepted,
          theme: theme,
        ),
        const SizedBox(height: 24),
        if (viewModel.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              viewModel.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        buildAuthButton(
          isLoading: viewModel.isLoading,
          onPressed: () async {
            final success = await viewModel.signup();
            if (success && context.mounted) {
              Navigator.pop(context);
            }
          },
          text: 'Create Account',
          theme: theme,
        ),
      ],
    );
  }
}