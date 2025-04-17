import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  TextInputType? keyboardType,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: grayColor),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildPasswordField({
  required TextEditingController controller,
  required bool obscurePassword,
  required VoidCallback toggleVisibility,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscurePassword,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: grayColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: grayColor,
          ),
          onPressed: toggleVisibility,
        ),
      ],
    ),
  );
}

Widget buildTermsAcceptance({
  required bool termsAccepted,
  required Function(bool) setTermsAccepted,
  required ThemeData theme,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: termsAccepted,
        activeColor: theme.primaryColor,
        onChanged: (value) => setTermsAccepted(value ?? false),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(
            children: [
              Text(
                'I agree to the ',
                style: theme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to terms of service
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: theme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to privacy policy
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildAuthButton({
  required bool isLoading,
  required VoidCallback onPressed,
  required String text,
  required ThemeData theme,
}) {
  return ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Common heading for auth screens
Widget buildAuthHeader({
  required String title,
  required String subtitle,
  required ThemeData theme,
}) {
  return Column(
    children: [
      Text(
        title,
        style: theme.textTheme.headlineLarge?.copyWith(
          color: theme.primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    ],
  );
}

// Progress indicator for multi-step flows
Widget buildProgressIndicator({
  required int currentStep,
  required int totalSteps,
  required ThemeData theme,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalSteps, (index) {
      return Row(
        children: [
          Container(
            height: 4,
            width: 20,
            color: index == currentStep - 1
                ? theme.primaryColor
                : Colors.grey.shade300,
          ),
          if (index < totalSteps - 1) const SizedBox(width: 4),
        ],
      );
    }),
  );
}