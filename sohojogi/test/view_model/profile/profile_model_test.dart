import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';

void main() {
  group('ProfileModel', () {
    test('should create a ProfileModel instance with default values', () {
      final model = ProfileModel();
      expect(model.id, '');
      expect(model.fullName, '');
      expect(model.email, '');
      expect(model.phoneNumber, '');
      expect(model.gender, '');
      expect(model.profilePhotoUrl, null);
      expect(model.isEmailVerified, false);
    });

    test('should create a ProfileModel from map', () {
      final map = {
        'id': 'test-id',
        'full_name': 'John Doe',
        'email': 'john@example.com',
        'phone_number': '+1234567890',
        'gender': 'Male',
        'profile_photo_url': 'http://example.com/photo.jpg',
        'is_email_verified': true,
      };

      final model = ProfileModel.fromMap(map);
      expect(model.id, 'test-id');
      expect(model.fullName, 'John Doe');
      expect(model.email, 'john@example.com');
      expect(model.phoneNumber, '+1234567890');
      expect(model.gender, 'Male');
      expect(model.profilePhotoUrl, 'http://example.com/photo.jpg');
      expect(model.isEmailVerified, true);
    });

    test('should convert ProfileModel to map', () {
      final model = ProfileModel(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        gender: 'Male',
        profilePhotoUrl: 'http://example.com/photo.jpg',
        isEmailVerified: true,
      );

      final map = model.toMap();
      expect(map['full_name'], 'John Doe');
      expect(map['email'], 'john@example.com');
      expect(map['phone_number'], '+1234567890');
      expect(map['gender'], 'Male');
      expect(map['profile_photo_url'], 'http://example.com/photo.jpg');
      expect(map['is_email_verified'], true);
    });

    test('should validate profile data correctly', () {
      final validModel = ProfileModel(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        gender: 'Male',
      );
      expect(validModel.isValid, true);

      final invalidModel = ProfileModel(
        fullName: '',
        email: 'invalid-email',
        phoneNumber: 'invalid-phone',
        gender: '',
      );
      expect(invalidModel.isValid, false);
    });

    test('should copy profile model correctly', () {
      final original = ProfileModel(
        id: 'test-id',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        gender: 'Male',
      );

      final copy = original.copy();
      expect(copy.equals(original), true);
    });
  });
}