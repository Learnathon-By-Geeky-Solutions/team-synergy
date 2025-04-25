// lib/screens/home/services/home_service.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/home/models/home_models.dart';

class HomeDatabaseService {
  final _supabase = Supabase.instance.client;

  // Get top providers sorted by rating
  Future<List<ProviderModel>> getTopProviders({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('workers')
          .select('id, name, service_category, average_rating, review_count, profile_image_url')
          .order('average_rating', ascending: false)
          .limit(limit);

      return response.map<ProviderModel>((provider) => ProviderModel(
        id: provider['id'],
        name: provider['name'],
        service: provider['service_category'],
        rating: provider['average_rating'].toDouble(),
        reviews: provider['review_count'],
        image: provider['profile_image_url'] ?? 'https://via.placeholder.com/150',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching top providers: $e');
      return [];
    }
  }

  // Get service categories from database
  Future<List<ServiceModel>> getServiceCategories() async {
    try {
      final response = await _supabase
          .from('workers')
          .select('service_category')
          .limit(20);

      // Get unique categories
      final categories = <String>{};
      for (var item in response) {
        categories.add(item['service_category']);
      }

      return categories.map((category) => ServiceModel(
        name: category,
        icon: _getIconForCategory(category),
      )).toList();
    } catch (e) {
      debugPrint('Error fetching service categories: $e');
      return [
        ServiceModel(name: 'Cleaning', icon: Icons.cleaning_services),
        ServiceModel(name: 'Electrician', icon: Icons.electrical_services),
      ];
    }
  }

  // Helper to map category names to icons
  IconData _getIconForCategory(String category) {
    final Map<String, IconData> iconMap = {
      'Cleaning': Icons.cleaning_services,
      'Repairing': Icons.build,
      'Electrician': Icons.electrical_services,
      'Carpenter': Icons.handyman,
      'Plumbing': Icons.plumbing,
      'Painting': Icons.format_paint,
      'Gardening': Icons.grass,
      'Moving': Icons.local_shipping,
      'Laundry': Icons.local_laundry_service,
      'Cooking': Icons.restaurant,
      'Delivery': Icons.delivery_dining,
      'Tutoring': Icons.school,
    };

    return iconMap[category] ?? Icons.miscellaneous_services;
  }
}