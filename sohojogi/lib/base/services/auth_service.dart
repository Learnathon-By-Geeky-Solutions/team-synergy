import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  // Sign up with email and password
  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Insert user profile into the profile table
        await _supabase.from('profile').insert({
          'id': response.user!.id,
          'name': displayName,
          'email': email,
        });
        return null; // No error
      }
      return 'Sign-up failed. Please try again.';
    } catch (e) {
      return e.toString(); // Return the error message
    }
  }

  // Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        return null; // No error
      }
      return 'Sign-in failed. Please check your credentials.';
    } catch (e) {
      return e.toString(); // Return the error message
    }
  }

  // Send password reset email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // No error
    } catch (e) {
      return e.toString(); // Return the error message
    }
  }

  // Sign out
}