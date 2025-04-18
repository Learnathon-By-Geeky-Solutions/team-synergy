// lib/screens/location/views/location_list_view.dart

import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _savedLocations = [
    {'name': 'Home', 'address': 'Mirpur 14, Dhaka, 1206', 'icon': Icons.home},
    {'name': 'Work', 'address': 'Dhanmondi 27, Dhaka, 1209', 'icon': Icons.work},
  ];

  final List<Map<String, dynamic>> _recentLocations = [
    {'address': 'Gulshan 2, Dhaka, 1212', 'subAddress': 'Near Pink City Shopping Mall'},
    {'address': 'Uttara Sector 7, Dhaka, 1230', 'subAddress': 'Road No. 7, House 23'},
    {'address': 'Banani, Dhaka', 'subAddress': 'Road 11, Block C'},
  ];

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // Simulated search results based on query
      _searchResults = [
        {'address': 'Mirpur 10, Dhaka, 1216', 'subAddress': 'Near Sony Cinema Hall'},
        {'address': 'Mirpur DOHS, Dhaka, 1216', 'subAddress': 'Road No. 3, House 15'},
        {'address': 'Mirpur 1, Dhaka, 1216', 'subAddress': 'Shah Ali Market'},
        if (query.length > 3) {'address': 'Mirpur Cantonment, Dhaka', 'subAddress': 'Staff Quarter Area'},
        if (query.length > 4) {'address': 'Mirpur Ceramic, Dhaka', 'subAddress': 'Industrial Area, Rupnagar'},
      ].where((loc) => loc['address'].toString().toLowerCase().contains(query)).toList();
    });
  }

  void _selectLocation(String address) {
    Navigator.pop(context, address);
  }

  void _useCurrentLocation() {
    // In a real app, this would request device location permissions
    // and get the current location coordinates, then reverse geocode them
    final currentLocation = 'Mirpur 14, Dhaka, 1206'; // Simulated current location
    Navigator.pop(context, currentLocation);
  }

  void _chooseOnMap() {
    // In a real app, this would navigate to a map screen
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view will be implemented soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(
            color: isDarkMode ? lightColor : darkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? darkColor : lightColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: isDarkMode ? darkColor : lightColor,
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: isDarkMode ? lightColor : darkColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for location',
                  hintStyle: TextStyle(
                    color: isDarkMode ? lightGrayColor : grayColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDarkMode ? lightGrayColor : grayColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
          ),

          // Current location and Map selection
          Container(
            width: double.infinity,
            color: isDarkMode ? darkColor : lightColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Current location button
                OutlinedButton.icon(
                  onPressed: _useCurrentLocation,
                  icon: Icon(
                    Icons.my_location,
                    color: primaryColor,
                    size: 18,
                  ),
                  label: Text(
                    'Use current location',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),

                const SizedBox(height: 12),

                // Choose on map button
                OutlinedButton.icon(
                  onPressed: _chooseOnMap,
                  icon: Icon(
                    Icons.map,
                    color: secondaryColor,
                    size: 18,
                  ),
                  label: Text(
                    'Choose on map',
                    style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: secondaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 8,
            color: isDarkMode ? grayColor : Colors.grey[100],
          ),

          // Location lists (search results or saved/recent locations)
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildSavedAndRecentLocations(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No locations found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return ListTile(
          onTap: () => _selectLocation(location['address']),
          tileColor: isDarkMode ? darkColor : lightColor,
          leading: Icon(
            Icons.location_on,
            color: primaryColor,
          ),
          title: Text(
            location['address'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? lightColor : darkColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            location['subAddress'],
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildSavedAndRecentLocations() {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Saved locations
        if (_savedLocations.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: isDarkMode ? grayColor : Colors.grey[100],
            child: Text(
              'Saved Locations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
          ...List.generate(_savedLocations.length, (index) {
            final location = _savedLocations[index];
            return ListTile(
              onTap: () => _selectLocation(location['address']),
              tileColor: isDarkMode ? darkColor : lightColor,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  location['icon'],
                  color: primaryColor,
                  size: 20,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    location['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Saved',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                location['address'],
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          const Divider(height: 1, thickness: 1),
        ],

        // Recent locations
        if (_recentLocations.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: isDarkMode ? grayColor : Colors.grey[100],
            child: Text(
              'Recent Locations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
          ...List.generate(_recentLocations.length, (index) {
            final location = _recentLocations[index];
            return ListTile(
              onTap: () => _selectLocation(location['address']),
              tileColor: isDarkMode ? darkColor : lightColor,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  color: isDarkMode ? lightGrayColor : grayColor,
                  size: 20,
                ),
              ),
              title: Text(
                location['address'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? lightColor : darkColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                location['subAddress'],
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ],
      ],
    );
  }
}