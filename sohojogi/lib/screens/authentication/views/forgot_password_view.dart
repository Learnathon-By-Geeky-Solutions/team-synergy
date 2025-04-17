import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/forgot_password_view_model.dart';
import 'package:sohojogi/screens/authentication/views/otp_verification_view.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_screen_layout.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: const _ForgotPasswordViewContent(),
    );
  }
}

class _ForgotPasswordViewContent extends StatelessWidget {
  const _ForgotPasswordViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Forgot Password',
      subtitle: 'Enter your phone number to reset your password',
      showBackButton: true,
      children: [
        buildTextField(
          controller: viewModel.phoneController,
          hintText: 'Phone Number',
          keyboardType: TextInputType.phone,
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
            final success = await viewModel.sendOTP();
            if (success && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OTPVerificationView(),
                ),
              );
            }
          },
          text: 'Send OTP',
          theme: theme,
        ),
      ],
    );
  }
}