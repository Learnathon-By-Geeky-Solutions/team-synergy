import 'package:flutter/material.dart';
import '../models/location_model.dart';

class LocationViewModel extends ChangeNotifier {
  final List<LocationModel> _savedLocations = [
    LocationModel(
      name: 'Home',
      address: 'Mirpur 14, Dhaka, 1206',
      icon: Icons.home,
      isSaved: true,
    ),
    LocationModel(
      name: 'Work',
      address: 'Dhanmondi 27, Dhaka, 1209',
      icon: Icons.work,
      isSaved: true,
    ),
  ];

  final List<LocationModel> _recentLocations = [
    LocationModel(
      address: 'Gulshan 2, Dhaka, 1212',
      subAddress: 'Near Pink City Shopping Mall',
    ),
    LocationModel(
      address: 'Uttara Sector 7, Dhaka, 1230',
      subAddress: 'Road No. 7, House 23',
    ),
    LocationModel(
      address: 'Banani, Dhaka',
      subAddress: 'Road 11, Block C',
    ),
  ];

  List<LocationModel> _searchResults = [];
  bool _isSearching = false;

  List<LocationModel> get savedLocations => _savedLocations;
  List<LocationModel> get recentLocations => _recentLocations;
  List<LocationModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  void search(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    // Simulated search results based on query
    _searchResults = [
      LocationModel(
        address: 'Mirpur 10, Dhaka, 1216',
        subAddress: 'Near Sony Cinema Hall',
      ),
      LocationModel(
        address: 'Mirpur DOHS, Dhaka, 1216',
        subAddress: 'Road No. 3, House 15',
      ),
      LocationModel(
        address: 'Mirpur 1, Dhaka, 1216',
        subAddress: 'Shah Ali Market',
      ),
      if (query.length > 3)
        LocationModel(
          address: 'Mirpur Cantonment, Dhaka',
          subAddress: 'Staff Quarter Area',
        ),
      if (query.length > 4)
        LocationModel(
          address: 'Mirpur Ceramic, Dhaka',
          subAddress: 'Industrial Area, Rupnagar',
        ),
    ].where((loc) => loc.address.toLowerCase().contains(query.toLowerCase())).toList();

    notifyListeners();
  }

  void selectLocation(BuildContext context, String address) {
    Navigator.pop(context, address);
  }

  void useCurrentLocation(BuildContext context) {
    final currentLocation = getCurrentLocation();
    Navigator.pop(context, currentLocation);
  }

  void chooseOnMap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view will be implemented soon')),
    );
  }

  String getCurrentLocation() {
    return 'Mirpur 14, Dhaka, 1206'; // Simulated current location
  }
}