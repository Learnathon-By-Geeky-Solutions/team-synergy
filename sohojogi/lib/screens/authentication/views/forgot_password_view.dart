import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/views/success_view.dart';
import 'package:sohojogi/screens/authentication/view_model/forgot_password_view_model.dart';
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
  const _ForgotPasswordViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Forgot Password',
      subtitle: 'Enter your email to reset your password',
      showBackButton: true,
      children: [
        buildTextField(
          controller: viewModel.emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
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
            final success = await viewModel.sendPasswordResetEmail();
            if (success && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessView(),
                ),
              );
            }
          },
          text: 'Send Reset Email',
          theme: theme,
        ),
      ],
    );
  }
}