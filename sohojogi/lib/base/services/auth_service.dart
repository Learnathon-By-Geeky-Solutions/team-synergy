import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;
  AuthService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;


  Future<bool> sendOTP(String phoneNumber) async {
    try {
      //await _supabase.auth.signInWithOtp(phone: phoneNumber);
      return true;

    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify the OTP entered by the user
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
      //add logic to reset password
      return true;
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }
}
