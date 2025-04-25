// lib/screens/service_searched/view_models/service_searched_view_model.dart
import 'package:flutter/material.dart';
import '../../../base/services/worker_database_service.dart';
import '../models/service_provider_model.dart';
import 'package:geolocator/geolocator.dart';

class ServiceSearchedViewModel extends ChangeNotifier {
  final WorkerDatabaseService _databaseService = WorkerDatabaseService();

  // Search parameters
  String _searchQuery = '';
  String _currentLocation = 'Anywhere';
  double? _latitude;
  double? _longitude;
  Map<String, dynamic> _filters = {
    'minRating': 0.0,
    'categories': <String>[],
    'sortBy': 'Distance',
    'maxDistance': 10.0,
  };

  // Results state
  List<ServiceProviderModel> _serviceProviders = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  // Getters
  String get searchQuery => _searchQuery;
  String get currentLocation => _currentLocation;
  Map<String, dynamic> get filters => _filters;
  List<ServiceProviderModel> get serviceProviders => _serviceProviders;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;


// Update initialize method in ServiceSearchedViewModel
  Future<void> initialize(String query, String location) async {
    _searchQuery = query;
    _currentLocation = location;

    try {
      // Get device location
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Continue without location data
    }

    // Initial search
    _resetSearch();
    _performSearch();
  }

  // Set search query and re-search
  void setSearchQuery(String query) {
    _searchQuery = query;
    _resetSearch();
    _performSearch();
  }

  // Set location and re-search
  void setLocation(String location) {
    _currentLocation = location;
    _resetSearch();
    _performSearch();
  }

  // Apply filters and re-search
  void applyFilters(Map<String, dynamic> filters) {
    _filters = filters;
    _resetSearch();
    _performSearch();
  }

  // Load more data for pagination
  Future<void> loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    _currentPage++;
    _performSearch(isLoadingMore: true);
  }

  // Reset search parameters
  void _resetSearch() {
    _serviceProviders = [];
    _currentPage = 0;
    _hasMoreData = true;
  }

  // Main search function
  Future<void> _performSearch({bool isLoadingMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (!isLoadingMore) {
      notifyListeners();
    }

    try {
      // Get providers from database
      final offset = _currentPage * _itemsPerPage;
      final newProviders = await _databaseService.searchServiceProviders(
        query: _searchQuery,
        location: _currentLocation,
        userLatitude: _latitude,
        userLongitude: _longitude,
        filters: _filters,
        limit: _itemsPerPage,
        offset: offset,
      );

      // Update providers list
      if (isLoadingMore) {
        _serviceProviders.addAll(newProviders);
      } else {
        _serviceProviders = newProviders;
      }

      // Check if more data available
      _hasMoreData = newProviders.length == _itemsPerPage;

      // Get total count for debugging/informational purposes
      final totalCount = await _databaseService.getTotalCount(
        query: _searchQuery,
        location: _currentLocation,
        filters: _filters,
      );

      debugPrint('Total matching service providers: $totalCount');

    } catch (e) {
      debugPrint('Error searching for service providers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}