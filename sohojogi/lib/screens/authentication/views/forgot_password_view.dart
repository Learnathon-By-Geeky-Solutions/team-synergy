import 'package:flutter/material.dart';
import 'package:sohojogi/screens/authentication/view_model/forgot_password_view_model.dart';
import 'package:sohojogi/screens/authentication/views/otp_verification_view.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
              Text(
                'Forget Password',
                style: theme.textTheme.headlineLarge?.copyWith(color: theme.primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter phone number to verify your account',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: viewModel.phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Continue',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 20,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: 4,
                    width: 20,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}