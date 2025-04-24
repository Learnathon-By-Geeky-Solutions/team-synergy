import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../../../base/services/location_service.dart';
import '../views/map_location_selector.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  // Locations
  List<LocationModel> _savedLocations = [];
  List<LocationModel> _recentLocations = [];
  List<LocationModel> _searchResults = [];

  // Location selector state
  List<CountryModel> _countries = [];
  List<StateModel> _states = [];
  List<CityModel> _cities = [];
  List<AreaModel> _areas = [];

  CountryModel? _selectedCountry;
  StateModel? _selectedState;
  CityModel? _selectedCity;
  AreaModel? _selectedArea;
  String _streetAddress = '';

  // UI state
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  List<LocationModel> get savedLocations => _savedLocations;
  List<LocationModel> get recentLocations => _recentLocations;
  List<LocationModel> get searchResults => _searchResults;

  List<CountryModel> get countries => _countries;
  List<StateModel> get states => _states;
  List<CityModel> get cities => _cities;
  List<AreaModel> get areas => _areas;

  CountryModel? get selectedCountry => _selectedCountry;
  StateModel? get selectedState => _selectedState;
  CityModel? get selectedCity => _selectedCity;
  AreaModel? get selectedArea => _selectedArea;

  // Initialize the view model
  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load saved locations
      final userLocations = await _locationService.getSavedLocations();
      _savedLocations = userLocations.map((userLocation) => LocationModel(
        address: userLocation.formattedAddress,
        subAddress: userLocation.streetAddress ?? '',
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        isSaved: userLocation.isSaved,
        icon: userLocation.icon,
        name: userLocation.name,
      )).toList();

      _recentLocations = await _locationService.getRecentLocations();

      // Load countries for location selector
      _countries = await _locationService.getCountries();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load locations: $e';
      notifyListeners();
    }
  }

  // Search for locations
  void search(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;

    // Filter saved and recent locations based on search query
    final allLocations = [..._savedLocations, ..._recentLocations];
    _searchResults = allLocations.where((location) {
      final address = location.address.toLowerCase();
      final subAddress = location.subAddress.toLowerCase();
      final name = location.name?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return address.contains(searchQuery) ||
          subAddress.contains(searchQuery) ||
          name.contains(searchQuery);
    }).toList();

    notifyListeners();
  }

// Country selection
  void selectCountry(CountryModel country) async {
    _selectedCountry = country;
    _selectedState = null;
    _selectedCity = null;
    _selectedArea = null;
    _states = [];
    _cities = [];
    _areas = [];
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Use country.id directly as it is already an int
      _states = await _locationService.getStates(country.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load states: $e';
      notifyListeners();
    }
  }

// State selection
  void selectState(StateModel state) async {
    _selectedState = state;
    _selectedCity = null;
    _selectedArea = null;
    _cities = [];
    _areas = [];
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Use state.id directly as it is already an int
      _cities = await _locationService.getCities(state.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load cities: $e';
      notifyListeners();
    }
  }

// City selection
  void selectCity(CityModel city) async {
    _selectedCity = city;
    _selectedArea = null;
    _areas = [];
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Use city.id directly as it is already an int
      _areas = await _locationService.getAreas(city.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load areas: $e';
      notifyListeners();
    }
  }

  // Area selection
  void selectArea(AreaModel area) {
    _selectedArea = area;
    notifyListeners();
  }

  // Street address setter
  void setStreetAddress(String address) {
    _streetAddress = address;
  }

  // Use current location
  Future<LocationModel?> useCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Add to recent locations
      await _locationService.addRecentLocation(address);

      _recentLocations = await _locationService.getRecentLocations();
      notifyListeners();
      return address;
    } catch (e) {
      _errorMessage = 'Failed to get current location: $e';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
    }
  }

  // Navigate to map selector
  Future<LocationModel?> navigateToMapSelector(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapLocationSelector()),
    );

    if (result != null) {
      // Add to recent locations
      await _locationService.addRecentLocation(result);
      _recentLocations = await _locationService.getRecentLocations();
      notifyListeners();
      return result;
    }

    return null;
  }

  // Save a location
  Future<void> saveLocation(LocationModel location) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userLocation = UserLocationModel(
        id: 0,
        userId: '',
        name: location.name ?? 'Saved Location',
        countryId: _selectedCountry?.id ?? 0,
        stateId: _selectedState?.id ?? 0,
        cityId: _selectedCity?.id ?? 0,
        areaId: _selectedArea?.id,
        streetAddress: _streetAddress,
        latitude: location.latitude ?? 0,
        longitude: location.longitude ?? 0,
        isDefault: false,
        isSaved: true,
        createdAt: DateTime.now(),
        icon: location.icon,
        countryName: _selectedCountry?.name,
        stateName: _selectedState?.name,
        cityName: _selectedCity?.name,
        areaName: _selectedArea?.name,
      );

      await _locationService.saveLocation(userLocation);

      // Refresh saved locations
      _savedLocations = (await _locationService.getSavedLocations()).cast<LocationModel>();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save location: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}