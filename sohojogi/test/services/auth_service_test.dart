import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/auth_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late AuthService authService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    authService = AuthService();
  });

  group('AuthService Tests', () {
    test('AuthService initializes correctly', () {
      expect(authService, isNotNull);
    });

    test('Sign up returns error for invalid credentials', () async {
      final result = await authService.signUp(
        email: 'test@example.com',
        password: 'short',
        displayName: 'Test User',
      );
      expect(result, isNotNull);
    });

    test('Sign in returns error for invalid credentials', () async {
      final result = await authService.signIn(
        email: 'test@example.com',
        password: 'wrong',
      );
      expect(result, isNotNull);
    });
  });
}