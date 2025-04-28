import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/reset_password_view_model.dart';
import 'package:sohojogi/screens/authentication/views/success_view.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_screen_layout.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: const _ResetPasswordViewContent(),
    );
  }
}

class _ResetPasswordViewContent extends StatelessWidget {
  const _ResetPasswordViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResetPasswordViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Reset Password',
      subtitle: 'Enter your new password to reset it',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context), // Navigate back to OTPVerificationView
      children: [
        buildPasswordField(
          controller: viewModel.newPasswordController,
          obscurePassword: viewModel.obscureNewPassword,
          toggleVisibility: viewModel.toggleNewPasswordVisibility,
        ),
        const SizedBox(height: 16),
        buildPasswordField(
          controller: viewModel.confirmPasswordController,
          obscurePassword: viewModel.obscureConfirmPassword,
          toggleVisibility: viewModel.toggleConfirmPasswordVisibility,
        ),
        const SizedBox(height: 16),
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
            final success = await viewModel.resetPassword();
            if (success && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessView(),
                ),
              );
            }
          },
          text: 'Reset Password',
          theme: theme,
        ),
      ],
    );
  }
}