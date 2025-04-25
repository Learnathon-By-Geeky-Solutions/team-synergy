import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/signin_view_model.dart';
import 'package:sohojogi/screens/authentication/views/forgot_password_view.dart';
import 'package:sohojogi/screens/authentication/views/signup_view.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_screen_layout.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: const _SignInViewContent(),
    );
  }
}

class _SignInViewContent extends StatelessWidget {
  const _SignInViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Sign In',
      subtitle: 'Welcome to SOHOJOGI\nPlease sign in to continue',
      bottomNavigationWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: theme.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpView()),
              );
            },
            child: Text(
              'Sign Up',
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
          controller: viewModel.emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        buildPasswordField(
          controller: viewModel.passwordController,
          obscurePassword: viewModel.obscurePassword,
          toggleVisibility: viewModel.togglePasswordVisibility,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
              );
            },
            child: Text('Forget Password?', style: theme.textTheme.bodyMedium),
          ),
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
            final success = await viewModel.signIn();
            if (success && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          text: 'Log In',
          theme: theme,
        ),
      ],
    );
  }
}