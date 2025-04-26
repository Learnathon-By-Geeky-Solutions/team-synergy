import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;
  static const String _baseUrl = 'https://szcieomutldoegeoelke.supabase.co';

  AuthService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
        emailRedirectTo: '$_baseUrl/#/auth/callback',
      );

      if (response.user != null) {
        await _supabase.from('temp_users').insert({
          'id': response.user!.id,
          'name': displayName,
          'email': email,
        });
        return null;
      }
      return 'Sign-up failed. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

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
        // Check if profile exists
        final profile = await _supabase
            .from('profile')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (profile == null) {
          // Get temp data and create profile if email is verified
          if (response.user!.emailConfirmedAt != null) {
            final tempData = await _supabase
                .from('temp_users')
                .select()
                .eq('id', response.user!.id)
                .maybeSingle();

            if (tempData != null) {
              await _supabase.from('profile').insert({
                'id': response.user!.id,
                'name': tempData['name'],
                'email': tempData['email'],
                'is_email_verified': true,
              });

              await _supabase
                  .from('temp_users')
                  .delete()
                  .eq('id', response.user!.id);
            }
          }
        }
        return null;
      }
      return 'Sign-in failed. Please check your credentials.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> verifyEmail(String token) async {
    try {
      final User? user = _supabase.auth.currentUser;
      if (user != null && user.emailConfirmedAt != null) {
        final tempData = await _supabase
            .from('temp_users')
            .select()
            .eq('id', user.id)
            .single();

        // Insert into profile table
        await _supabase.from('profile').insert({
          'id': user.id,
          'name': tempData['name'],
          'email': tempData['email'],
          'is_email_verified': true,
        });

        // Delete temp data
        await _supabase.from('temp_users').delete().eq('id', user.id);
        return null;
      }
      return 'Email not verified or user not found';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: '$_baseUrl/#/auth/reset-password',
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Future<bool> isEmailVerified() async {
    final user = getCurrentUser();
    if (user != null) {
      return user.emailConfirmedAt != null;
    }
    return false;
  }
}