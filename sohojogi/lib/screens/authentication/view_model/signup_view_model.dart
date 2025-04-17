import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/authentication/view_model/base_auth_view_model.dart';

class SignUpViewModel extends BaseAuthViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  Future<bool> signup() async {
    if (!_validateInputs()) {
      return false;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      var user = {
        'phone_number': phoneController.text,
        'name': nameController.text,
        'password': passwordController.text
      };

      await Supabase.instance.client.from('user').insert(user);
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      setErrorMessage('Registration failed');
      return false;
    }
  }

  bool _validateInputs() {
    if (!validateField(nameController.text, 'name')) {
      return false;
    }

    if (!validateField(phoneController.text, 'phone number')) {
      return false;
    }

    if (!validateField(passwordController.text, 'password')) {
      return false;
    }

    if (!_termsAccepted) {
      setErrorMessage('Please accept the terms of service');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}