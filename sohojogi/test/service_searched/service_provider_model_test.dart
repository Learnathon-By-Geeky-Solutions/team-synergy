import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';

void main() {
  group('ServiceProviderModel', () {
    test('constructor creates instance with required parameters', () {
      final provider = ServiceProviderModel(
        id: '123',
        name: 'John Doe',
        profileImage: 'image.jpg',
        location: 'Dhaka',
        latitude: 23.8103,
        longitude: 90.4125,
        serviceCategory: 'Plumbing',
        email: 'john@example.com',
        phoneNumber: '1234567890',
        gender: Gender.male,
        rating: 4.5,
        reviewCount: 10,
      );

      expect(provider.id, '123');
      expect(provider.name, 'John Doe');
      expect(provider.profileImage, 'image.jpg');
      expect(provider.location, 'Dhaka');
      expect(provider.latitude, 23.8103);
      expect(provider.longitude, 90.4125);
      expect(provider.serviceCategory, 'Plumbing');
      expect(provider.email, 'john@example.com');
      expect(provider.phoneNumber, '1234567890');
      expect(provider.gender, Gender.male);
      expect(provider.rating, 4.5);
      expect(provider.reviewCount, 10);
      expect(provider.completionRate, 95.0); // default value
      expect(provider.isVerified, false); // default value
    });

    test('fromJson creates correct instance with complete data', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'profile_image_url': 'image.jpg',
        'location': 'Dhaka',
        'latitude': 23.8103,
        'longitude': 90.4125,
        'service_category': 'Plumbing',
        'email': 'john@example.com',
        'phone_number': '1234567890',
        'gender': 'male',
        'bio': 'Experienced plumber',
        'average_rating': 4.5,
        'review_count': 10,
        'completion_rate': 98.0,
        'jobs_completed': 50,
        'years_of_experience': 5,
        'is_verified': true,
        'categories': ['Plumbing', 'Repairs']
      };

      final provider = ServiceProviderModel.fromJson(json);

      expect(provider.id, '123');
      expect(provider.name, 'John Doe');
      expect(provider.profileImage, 'image.jpg');
      expect(provider.gender, Gender.male);
      expect(provider.bio, 'Experienced plumber');
      expect(provider.rating, 4.5);
      expect(provider.completionRate, 98.0);
      expect(provider.jobsCompleted, 50);
      expect(provider.yearsOfExperience, 5);
      expect(provider.isVerified, true);
      expect(provider.categories, ['Plumbing', 'Repairs']);
    });

    test('fromJson creates instance with default values for missing data', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'location': 'Dhaka',
        'service_category': 'Plumbing',
        'email': 'john@example.com',
        'phone_number': '1234567890',
        'gender': 'male',
      };

      final provider = ServiceProviderModel.fromJson(json);

      expect(provider.profileImage, 'https://via.placeholder.com/150');
      expect(provider.bio, '');
      expect(provider.rating, 0.0);
      expect(provider.reviewCount, 0);
      expect(provider.completionRate, 95.0);
      expect(provider.jobsCompleted, 0);
      expect(provider.yearsOfExperience, 1);
      expect(provider.isVerified, false);
      expect(provider.categories, isEmpty);
    });

    test('gender is correctly parsed from different string values', () {
      expect(ServiceProviderModel.fromJson({'id': '1', 'name': 'Test', 'location': 'Test',
        'service_category': 'Test', 'email': 'test', 'phone_number': 'test', 'gender': 'male'}).gender, Gender.male);

      expect(ServiceProviderModel.fromJson({'id': '1', 'name': 'Test', 'location': 'Test',
        'service_category': 'Test', 'email': 'test', 'phone_number': 'test', 'gender': 'female'}).gender, Gender.female);

      expect(ServiceProviderModel.fromJson({'id': '1', 'name': 'Test', 'location': 'Test',
        'service_category': 'Test', 'email': 'test', 'phone_number': 'test', 'gender': 'other'}).gender, Gender.other);

      expect(ServiceProviderModel.fromJson({'id': '1', 'name': 'Test', 'location': 'Test',
        'service_category': 'Test', 'email': 'test', 'phone_number': 'test', 'gender': 'unknown'}).gender, Gender.other);
    });
  });
}