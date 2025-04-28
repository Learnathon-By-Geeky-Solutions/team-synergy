import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/profile_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late ProfileService profileService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    profileService = ProfileService();
  });

  group('ProfileService Tests', () {
    test('ProfileService initializes correctly', () {
      expect(profileService, isNotNull);
    });

    test('fetchProfile returns error for invalid user', () async {
      try {
        await profileService.fetchProfile('invalid-id');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('updateProfile returns error for invalid user', () async {
      try {
        await profileService.updateProfile(
          'invalid-id',
          {'full_name': 'Test User'},
        );
        fail('Should throw an exception');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('uploadProfilePicture returns error for invalid file', () async {
      try {
        await profileService.uploadProfilePicture(
          'test-id',
          'invalid/path.jpg',
        );
        fail('Should throw an exception');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}