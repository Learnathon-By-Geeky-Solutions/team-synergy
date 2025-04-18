import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/base/services/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
  });

  group('AuthService Tests', () {
    test('Send OTP successfully', () async {
      final result = await authService.sendOTP('1234567890');
      expect(result, true);
    });

    test('Verify OTP successfully', () async {
      final result = await authService.verifyOTP(phoneNumber: '1234567890', otp: '123456');
      expect(result, true);
    });

    test('Reset password successfully', () async {
      final result = await authService.resetPassword(phoneNumber: '1234567890', newPassword: 'password123');
      expect(result, true);
    });
  });
}