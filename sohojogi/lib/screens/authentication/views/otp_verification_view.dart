import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/authentication/view_model/otp_verification_view_model.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_screen_layout.dart';
import 'package:sohojogi/screens/authentication/views/reset_password_view.dart';
import 'package:sohojogi/screens/authentication/widgets/auth_widgets.dart';

class OTPVerificationView extends StatelessWidget {
  const OTPVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OTPVerificationViewModel(),
      child: const _OTPVerificationViewContent(),
    );
  }
}

class _OTPVerificationViewContent extends StatelessWidget {
  const _OTPVerificationViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OTPVerificationViewModel>();
    final theme = Theme.of(context);

    return AuthScreenLayout(
      title: 'Enter OTP',
      subtitle: 'Enter the 6-digit verification code sent to ${viewModel.phoneNumber}',
      showBackButton: true,
      onBackPressed: () => Navigator.pop(context),
      children: [
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
            child: Text('Resend OTP',style: theme.textTheme.bodyMedium),
          ),
        ),
        const SizedBox(height: 16),
        buildAuthButton(
          isLoading: viewModel.isLoading,
          onPressed: () async {
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
          text: 'Reset Password',
          theme: theme,
        ),
      ],
    );
  }
}