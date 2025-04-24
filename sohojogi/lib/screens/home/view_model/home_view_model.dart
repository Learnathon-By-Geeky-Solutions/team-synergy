import 'package:flutter/material.dart';
import '../models/home_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  String _currentLocation = 'Select your location';
  int _currentBannerPage = 0;
  static const String locationKey = 'user_selected_location';

  HomeViewModel() {
    _loadSavedLocation();
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

  // Getters
  String get currentLocation => _currentLocation;
  int get currentBannerPage => _currentBannerPage;
  List<BannerModel> get banners => _banners;
  List<ServiceModel> get services => _services;
  List<ProviderModel> get topProviders => _topProviders;

  // Data sources
  final List<BannerModel> _banners = [
    BannerModel(title: 'CASHON Insurance', color: const Color(0xFF2196F3)),
    BannerModel(title: 'Family Coverage Plan', color: const Color(0xFFFFC107)),
    BannerModel(title: 'Premium Protection', color: const Color(0xFF4CAF50)),
  ];

  // List of services
  final List<ServiceModel> _services = [
    ServiceModel(name: 'Cleaning', icon: Icons.cleaning_services),
    ServiceModel(name: 'Repairing', icon: Icons.build),
    ServiceModel(name: 'Electrician', icon: Icons.electrical_services),
    ServiceModel(name: 'Carpenter', icon: Icons.handyman),
    ServiceModel(name: 'Plumbing', icon: Icons.plumbing),
    ServiceModel(name: 'Painting', icon: Icons.format_paint),
    ServiceModel(name: 'Gardening', icon: Icons.grass),
    ServiceModel(name: 'Moving', icon: Icons.local_shipping),
    ServiceModel(name: 'Laundry', icon: Icons.local_laundry_service),
    ServiceModel(name: 'Cooking', icon: Icons.restaurant),
    ServiceModel(name: 'Delivery', icon: Icons.delivery_dining),
    ServiceModel(name: 'Tutoring', icon: Icons.school),
  ];

  // List of top providers
  final List<ProviderModel> _topProviders = [
    ProviderModel(
      name: 'John Doe',
      service: 'Plumbing',
      rating: 4.9,
      reviews: 253,
      image: 'https://randomuser.me/api/portraits/men/32.jpg',
      id: '1',
    ),
    ProviderModel(
      name: 'Sarah Smith',
      service: 'Cleaning',
      rating: 4.8,
      reviews: 187,
      image: 'https://randomuser.me/api/portraits/women/44.jpg',
      id: '2',
    ),
    ProviderModel(
      name: 'David Wilson',
      service: 'Electrician',
      rating: 4.7,
      reviews: 129,
      image: 'https://randomuser.me/api/portraits/men/56.jpg',
      id: '3',
    ),
    ProviderModel(
      name: 'Emma Johnson',
      service: 'Tutoring',
      rating: 4.9,
      reviews: 201,
      image: 'https://randomuser.me/api/portraits/women/33.jpg',
      id: '4',
    ),
    ProviderModel(
      name: 'Michael Brown',
      service: 'Carpenter',
      rating: 4.6,
      reviews: 142,
      image: 'https://randomuser.me/api/portraits/men/78.jpg',
      id: '5',
    ),
    ProviderModel(
      name: 'Lisa Garcia',
      service: 'Gardening',
      rating: 4.7,
      reviews: 118,
      image: 'https://randomuser.me/api/portraits/women/65.jpg',
      id: '6',
    ),
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
}