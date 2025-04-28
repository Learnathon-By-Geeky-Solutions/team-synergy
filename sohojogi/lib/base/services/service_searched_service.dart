import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import '../../screens/service_searched/models/service_provider_model.dart';

class ServiceSearchedService {
  final _supabase = Supabase.instance.client;

  Future<List<ServiceProviderModel>> searchServiceProviders({
    required String searchQuery,
    required double userLatitude,
    required double userLongitude,
    double? minRating,
    List<String>? categories,
    String? sortBy,
    double? maxDistance,
  }) async {
    try {
      var supabaseQuery = _supabase.from('workers').select();

      if (searchQuery.isNotEmpty) {
        supabaseQuery = supabaseQuery.or('name.ilike.%$searchQuery%,service_category.ilike.%$searchQuery%,location.ilike.%$searchQuery%');
      }

      if (minRating != null && minRating > 0) {
        supabaseQuery = supabaseQuery.gte('average_rating', minRating);
      }

      if (categories != null && categories.isNotEmpty) {
        supabaseQuery = supabaseQuery.contains('service_category', categories);
      }

      final response = await supabaseQuery;
      List<ServiceProviderModel> providers = _mapWorkersToProviders(
        response,
        userLatitude,
        userLongitude,
        maxDistance,
      );

      return _sortProviders(providers, sortBy);
    } catch (e) {
      debugPrint('Error searching service providers: $e');
      return [];
    }
  }

  List<ServiceProviderModel> _mapWorkersToProviders(
      List<dynamic> workers,
      double userLatitude,
      double userLongitude,
      double? maxDistance,
      ) {
    List<ServiceProviderModel> providers = [];

    for (var worker in workers) {
      final distance = _calculateDistance(
        userLatitude,
        userLongitude,
        worker['latitude'] ?? 0,
        worker['longitude'] ?? 0,
      );

      if (maxDistance != null && distance > maxDistance) continue;

      Gender gender = Gender.other;
      if (worker['gender'] == 'male') {
        gender = Gender.male;
      } else if (worker['gender'] == 'female') {
        gender = Gender.female;
      }

      providers.add(ServiceProviderModel(
        id: worker['id'],
        name: worker['name'],
        profileImage: worker['profile_image_url'] ?? 'https://via.placeholder.com/150',
        location: worker['location'],
        serviceCategory: worker['service_category'],
        rating: worker['average_rating'].toDouble(),
        reviewCount: worker['review_count'],
        email: worker['email'],
        phoneNumber: worker['phone_number'],
        gender: gender,
        latitude: worker['latitude'] ?? 0,
        longitude: worker['longitude'] ?? 0,
        distance: distance,
      ));
    }
    return providers;
  }

  List<ServiceProviderModel> _sortProviders(
      List<ServiceProviderModel> providers,
      String? sortBy,
      ) {
    if (sortBy == null) return providers;

    switch (sortBy) {
      case 'Rating':
        providers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        providers.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Price: Low to High':
      case 'Price: High to Low':
      // Price sorting implementation would go here
        break;
    }
    return providers;
  }

  // Helper method to calculate distance between two coordinates (in kilometers)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371.0; // in kilometers

    // Convert degrees to radians
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    // Haversine formula
    final a =
        sin(dLat/2) * sin(dLat/2) +
            cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
                sin(dLon/2) * sin(dLon/2);

    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    final distance = earthRadius * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}