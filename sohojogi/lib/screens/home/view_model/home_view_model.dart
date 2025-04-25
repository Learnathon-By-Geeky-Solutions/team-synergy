import 'package:flutter/material.dart';
import '../../../base/services/home_database_service.dart';
import '../../service_searched/views/service_searched_list_view.dart';
import '../models/home_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeDatabaseService _databaseService = HomeDatabaseService();

  String _currentLocation = 'Select your location';
  int _currentBannerPage = 0;
  static const String locationKey = 'user_selected_location';

  bool _isLoading = true;
  List<ServiceModel> _services = [];
  List<ProviderModel> _topProviders = [];

  HomeViewModel() {
    _loadSavedLocation();
    _loadInitialData();
  }

  // Load location from SharedPreferences
  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocation = prefs.getString(locationKey);
    if (savedLocation != null && savedLocation.isNotEmpty) {
      _currentLocation = savedLocation;
      notifyListeners();
    }
  }

  // Load initial data from database
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load service categories
      final services = await _databaseService.getServiceCategories();
      _services = services;

      // Load top providers
      final providers = await _databaseService.getTopProviders();
      _topProviders = providers;
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Getters
  String get currentLocation => _currentLocation;
  int get currentBannerPage => _currentBannerPage;
  bool get isLoading => _isLoading;
  List<BannerModel> get banners => _banners;
  List<ServiceModel> get services => _services;
  List<ProviderModel> get topProviders => _topProviders;

  // Banner data (could be moved to database later)
  final List<BannerModel> _banners = [
    BannerModel(title: 'CASHON Insurance', color: const Color(0xFF2196F3)),
    BannerModel(title: 'Family Coverage Plan', color: const Color(0xFFFFC107)),
    BannerModel(title: 'Premium Protection', color: const Color(0xFF4CAF50)),
  ];

  // Methods
  void setCurrentBannerPage(int page) {
    _currentBannerPage = page;
    notifyListeners();
  }

  void updateLocation(String location) {
    _currentLocation = location;
    _saveLocation(location);
    notifyListeners();
  }

  Future<void> _saveLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(locationKey, location);
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  // Navigation method for when a service category is selected
  void navigateToServiceCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceSearchedListView(
          searchQuery: category,
          currentLocation: _currentLocation,
        ),
      ),
    );
  }

  // Search functionality
  void performSearch(BuildContext context, String query) {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceSearchedListView(
          searchQuery: query,
          currentLocation: _currentLocation,
        ),
      ),
    );
  }
}