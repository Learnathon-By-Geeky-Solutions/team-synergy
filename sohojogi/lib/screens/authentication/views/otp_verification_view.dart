import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/otp_verification_view_model.dart';
import 'package:sohojogi/screens/authentication/views/reset_password_view.dart';

class OTPVerificationView extends StatelessWidget {
  const OTPVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OTPVerificationViewModel(),
      child: const _OTPVerificationViewContent(),
    );
  }
}

class _OTPVerificationViewContent extends StatelessWidget {
  const _OTPVerificationViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OTPVerificationViewModel>();
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
                'Enter OTP',
                style: theme.textTheme.headlineLarge?.copyWith(color: theme.primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit verification code sent to ${viewModel.phoneNumber}',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.phone,
                onChanged: (value) => viewModel.otpCode = value,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: const Color(0xFFF5F7FA),
                  inactiveFillColor: const Color(0xFFF5F7FA),
                  inactiveColor: Colors.grey,
                  selectedFillColor: const Color(0xFFF5F7FA),
                  selectedColor: theme.primaryColor,
                ),
                cursorColor: Colors.black,
                animationType: AnimationType.fade,
              ),
              const SizedBox(height: 16),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => viewModel.resendOTP(),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                  final success = await viewModel.verifyOTP();
                  if (success && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordView(),
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
                  'Reset Password',
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
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 4),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}