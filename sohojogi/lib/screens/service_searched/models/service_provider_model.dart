// lib/screens/service_searched/models/service_provider_model.dart
enum Gender { male, female, other }

class ServiceProviderModel {
  final String id;
  final String name;
  final String profileImage;
  final String location;
  final double latitude;
  final double longitude;
  final String serviceCategory;
  final String email;
  final String phoneNumber;
  final Gender gender;
  final String bio;
  final double rating;
  final int reviewCount;
  final double completionRate;
  final int jobsCompleted;
  final int yearsOfExperience;
  final bool isVerified;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.serviceCategory,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.bio = '',
    required this.rating,
    required this.reviewCount,
    this.completionRate = 95.0,
    this.jobsCompleted = 0,
    this.yearsOfExperience = 1,
    this.isVerified = false,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    Gender genderFromString(String gender) {
      switch (gender.toLowerCase()) {
        case 'male':
          return Gender.male;
        case 'female':
          return Gender.female;
        default:
          return Gender.other;
      }
    }

    return ServiceProviderModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image_url'] ?? 'https://via.placeholder.com/150',
      location: json['location'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      serviceCategory: json['service_category'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: genderFromString(json['gender']),
      bio: json['bio'] ?? '',
      rating: json['average_rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      completionRate: json['completion_rate']?.toDouble() ?? 95.0,
      jobsCompleted: json['jobs_completed'] ?? 0,
      yearsOfExperience: json['years_of_experience'] ?? 1,
      isVerified: json['is_verified'] ?? false,
    );
  }
}