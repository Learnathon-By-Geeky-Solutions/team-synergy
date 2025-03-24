import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/authentication/view_model/signup_view_model.dart';

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
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: grayColor),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildPasswordField(SignUpViewModel viewModel) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: viewModel.passwordController,
            obscureText: viewModel.obscurePassword,
            style: TextStyle(color: Colors.black),
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
            viewModel.obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: grayColor,
          ),
          onPressed: viewModel.togglePasswordVisibility,
        ),
      ],
    ),
  );
}

Widget buildTermsAcceptance(SignUpViewModel viewModel, ThemeData theme) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: viewModel.termsAccepted,
        activeColor: theme.primaryColor,
        onChanged: (value) => viewModel.setTermsAccepted(value ?? false),
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
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}