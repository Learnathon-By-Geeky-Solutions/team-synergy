import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class SignInViewModel extends BaseAuthViewModel {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> signIn() async {
    if (!_validateInputs()) {
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      // Check if user exists in the database
      await Supabase.instance.client
          .from('user')
          .select()
          .eq('phone_number', phoneController.text)
          .eq('password', passwordController.text)
          .single();

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      setErrorMessage('Authentication failed');
      return false;
    }
  }

  bool _validateInputs() {
    if (!validateField(phoneController.text, 'phone number')) {
      return false;
    }

    if (!validateField(passwordController.text, 'password')) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}