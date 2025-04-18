// lib/screens/service_searched/models/service_provider_model.dart
enum Gender { male, female, other }

class ServiceProviderModel {
  final String id;
  final String name;
  final String profileImage;
  final String location;
  final String serviceCategory;
  final double rating;
  final int reviewCount;
  final String email;
  final String phoneNumber;
  final Gender gender;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.location,
    required this.serviceCategory,
    required this.rating,
    required this.reviewCount,
    required this.email,
    required this.phoneNumber,
    required this.gender,
  });
}