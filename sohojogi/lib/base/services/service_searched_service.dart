// lib/screens/service_searched/services/service_searched_service.dart
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
      // Start building the Supabase query
      var supabaseQuery = _supabase.from('workers').select();

      // Apply search query filter
      if (searchQuery.isNotEmpty) {
        // Search in name, service_category, and location
        supabaseQuery = supabaseQuery.or('name.ilike.%$searchQuery%,service_category.ilike.%$searchQuery%,location.ilike.%$searchQuery%');
      }

      // Apply rating filter
      if (minRating != null && minRating > 0) {
        supabaseQuery = supabaseQuery.gte('average_rating', minRating);
      }

      // Apply category filter
      if (categories != null && categories.isNotEmpty) {
        supabaseQuery = supabaseQuery.contains('service_category', categories);
      }

      // Execute the query
      final response = await supabaseQuery;

      // Map the response to ServiceProviderModel objects
      List<ServiceProviderModel> providers = [];

      for (var worker in response) {
        // Calculate distance
        final distance = _calculateDistance(
            userLatitude,
            userLongitude,
            worker['latitude'] ?? 0,
            worker['longitude'] ?? 0
        );

        // Apply distance filter
        if (maxDistance != null && distance > maxDistance) {
          continue;  // Skip this provider if beyond max distance
        }

        // Determine gender
        Gender gender = Gender.other;
        if (worker['gender'] == 'male') {
          gender = Gender.male;
        } else if (worker['gender'] == 'female') {
          gender = Gender.female;
        }

        // Create the provider model
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

      // Apply sorting
      if (sortBy != null) {
        switch (sortBy) {
          case 'Rating':
            providers.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'Distance':
            providers.sort((a, b) => a.distance.compareTo(b.distance));
            break;
          case 'Price: Low to High':
          // For price sorting, we'd need to fetch and join with service prices
          // Simplified implementation for now
            break;
          case 'Price: High to Low':
          // Simplified implementation for now
            break;
        }
      }

      return providers;
    } catch (e) {
      debugPrint('Error searching service providers: $e');
      return [];
    }
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