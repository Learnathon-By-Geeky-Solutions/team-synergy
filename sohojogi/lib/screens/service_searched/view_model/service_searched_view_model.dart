import 'package:flutter/material.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/base/services/home_service.dart';

import '../../../base/services/service_searched_service.dart';

class ServiceSearchedViewModel extends ChangeNotifier {
  final ServiceSearchedService _service = ServiceSearchedService();
  final HomeDatabaseService _homeService = HomeDatabaseService();

  List<ServiceProviderModel> _serviceProviders = [];
  List<String> _availableCategories = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _currentFilters;

  // Getters
  List<ServiceProviderModel> get serviceProviders => _serviceProviders;
  List<String> get availableCategories => _availableCategories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentFilters => _currentFilters;

  // Initialize and load categories
  Future<void> init() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load categories from real data
      final services = await _homeService.getServiceCategories();
      _availableCategories = services.map((service) => service.name).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search service providers with optional filters
  Future<void> searchServiceProviders({
    required String searchQuery,
    required double userLatitude,
    required double userLongitude,
    Map<String, dynamic>? filters,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Save current filters
      _currentFilters = filters;

      // Extract filter values
      final double? minRating = filters?['minRating'];
      final List<String>? categories = filters?['categories']?.cast<String>();
      final String? sortBy = filters?['sortBy'];
      final double? maxDistance = filters?['maxDistance'];

      // Call service to get real data from Supabase
      _serviceProviders = await _service.searchServiceProviders(
        searchQuery: searchQuery,
        userLatitude: userLatitude,
        userLongitude: userLongitude,
        minRating: minRating,
        categories: categories,
        sortBy: sortBy,
        maxDistance: maxDistance,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to search service providers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Apply filters to existing search
  Future<void> applyFilters(
      Map<String, dynamic> filters,
      String searchQuery,
      double userLatitude,
      double userLongitude,
      ) async {
    await searchServiceProviders(
      searchQuery: searchQuery,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      filters: filters,
    );
  }
}