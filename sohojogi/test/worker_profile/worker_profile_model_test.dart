import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';

void main() {
  group('WorkerProfileModel', () {
    test('creates instance from json', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone_number': '+8801234567890',
        'profile_image_url': 'https://example.com/image.jpg',
        'location': 'Dhaka',
        'latitude': 23.8103,
        'longitude': 90.4125,
        'gender': 0, // 0 represents Gender.male
        'average_rating': 4.5,
        'review_count': 10,
        'service_category': 'Plumbing',
        'bio': 'Expert plumber',
        'completion_rate': 95.0,
        'jobs_completed': 50,
        'years_of_experience': 5,
        'is_verified': true,
        'services': [],
        'skills': ['Plumbing', 'Repair'],
        'availability': [],
        'reviews': [],
        'portfolio_items': [],
        'qualifications': []
      };

      final model = WorkerProfileModel.fromJson(json);

      expect(model.id, '123');
      expect(model.name, 'John Doe');
      expect(model.rating, 4.5);
      expect(model.isVerified, true);
    });

    test('converts to json correctly', () {
      final model = WorkerProfileModel(
          id: '123',
          name: 'John Doe',
          email: 'john@example.com',
          phoneNumber: '+8801234567890',
          profileImage: 'https://example.com/image.jpg',
          location: 'Dhaka',
          latitude: 23.8103,
          longitude: 90.4125,
          gender: Gender.male,
          rating: 4.5,
          reviewCount: 10,
          serviceCategory: 'Plumbing',
          bio: 'Expert plumber',
          completionRate: 95.0,
          jobsCompleted: 50,
          yearsOfExperience: 5,
          isVerified: true,
          services: [],
          skills: ['Plumbing', 'Repair'],
          availability: [],
          reviews: [],
          portfolioItems: [],
          qualifications: [], ratingBreakdown: RatingBreakdown(
        fiveStars: 5,
        fourStars: 3,
        threeStars: 1,
        twoStars: 1,
        oneStars: 0,
      ),
      );

      final json = model.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['average_rating'], 4.5);
      expect(json['is_verified'], true);
    });
  });
}