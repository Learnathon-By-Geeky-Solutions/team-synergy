import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/authentication/view_model/signin_view_model.dart';

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

Widget buildPasswordField(SignInViewModel viewModel) {
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