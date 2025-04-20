import 'package:flutter/material.dart';
import '../models/service_provider_model.dart';

class ServiceSearchedViewModel extends ChangeNotifier {
  List<ServiceProviderModel> _serviceProviders = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  String _currentLocation = '';
  String _searchQuery = '';
  Map<String, dynamic> _filters = {
    'minRating': 0.0,
    'categories': <String>[],
    'sortBy': 'Rating',
    'maxDistance': 10.0,
  };

  List<ServiceProviderModel> get serviceProviders => _serviceProviders;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  String get currentLocation => _currentLocation;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get filters => _filters;

  void initialize(String searchQuery, String currentLocation) {
    _searchQuery = searchQuery;
    _currentLocation = currentLocation;
    loadInitialData();
  }

  void setLocation(String location) {
    _currentLocation = location;
    resetAndReload();
  }

  void setSearchQuery(String query) {
    if (query.isNotEmpty) {
      _searchQuery = query;
      resetAndReload();
    }
  }

  void applyFilters(Map<String, dynamic> filters) {
    _filters = filters;
    resetAndReload();
  }

  void resetAndReload() {
    _serviceProviders = [];
    _isLoading = true;
    _hasMoreData = true;
    notifyListeners();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network request with delay
    await Future.delayed(const Duration(seconds: 1));

    _serviceProviders = getDummyServiceProviders();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if (!_hasMoreData || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network request with delay
    await Future.delayed(const Duration(seconds: 1));

    if (_serviceProviders.length >= 15) {
      _hasMoreData = false;
    } else {
      _serviceProviders.addAll(getDummyServiceProviders());
    }

    _isLoading = false;
    notifyListeners();
  }

  List<ServiceProviderModel> getDummyServiceProviders() {
    // Generate dummy service providers for testing
    return List.generate(
      5,
          (index) => ServiceProviderModel(
        id: 'id_${index + _serviceProviders.length}',
        name: 'Provider ${index + _serviceProviders.length + 1}',
        profileImage: 'https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${20 + index + _serviceProviders.length}.jpg',
        location: _currentLocation,
        serviceCategory: _searchQuery,
        rating: 3.5 + (index % 3) * 0.5,
        reviewCount: 50 + (index * 30),
        email: 'provider${index + _serviceProviders.length + 1}@example.com',
        phoneNumber: '+880 1${700000000 + (index + _serviceProviders.length) * 11111}',
        gender: index % 2 == 0 ? Gender.male : Gender.female,
      ),
    );
  }
}