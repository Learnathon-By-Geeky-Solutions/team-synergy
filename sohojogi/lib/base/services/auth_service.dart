import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      // final otpResponse = await _supabase.auth.signInWithOtp(phone: phoneNumber);
      // return true;

      // Generate OTP and use self made table
      // var rng = Random();
      // var code = rng.nextInt(90000) + 10000;
      //
      // // Save OTP to Supabase
      // await _supabase.from('otp_requests').insert({
      //   'phone_number': phoneNumber,
      //   'created_at': DateTime.now().toIso8601String(),
      //   'otp': code,
      // });

      return true;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  Future<bool> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      // final response = await _supabase.auth.verifyOTP(
      //   phone: phoneNumber,
      //   token: otp,
      //   type: OtpType.sms,
      // );

      return true;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  Future<bool> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      //add logic for reset password
      return true;
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }
}
