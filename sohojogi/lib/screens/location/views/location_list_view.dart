import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import '../view_model/location_view_model.dart';
import '../widgets/location_card.dart';
import '../widgets/location_search_header.dart';

class LocationListView extends StatefulWidget {
  const LocationListView({super.key});

  @override
  State<LocationListView> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationListView> {
  final TextEditingController _searchController = TextEditingController();

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
    final viewModel = Provider.of<LocationViewModel>(context, listen: false);
    viewModel.search(_searchController.text);
  }

  void _selectLocation(String address) {
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final viewModel = Provider.of<LocationViewModel>(context);

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
          // Using the dedicated search header widget instead of duplicating code
          LocationSearchHeader(
            searchController: _searchController,
            useCurrentLocation: () {
              final viewModel = Provider.of<LocationViewModel>(context, listen: false);
              final currentLocation = viewModel.getCurrentLocation();
              Navigator.pop(context, currentLocation);
            },
            chooseOnMap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map view will be implemented soon')),
              );
            },
            isDarkMode: isDarkMode,
          ),

          // Location lists
          Expanded(
            child: viewModel.isSearching
                ? _buildSearchResults(viewModel, isDarkMode)
                : _buildSavedAndRecentLocations(viewModel, isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 48, color: isDarkMode ? lightGrayColor : grayColor),
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
              style: TextStyle(fontSize: 14, color: isDarkMode ? lightGrayColor : grayColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.searchResults.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final location = viewModel.searchResults[index];
        return LocationCard(
          location: location,
          onTap: () => _selectLocation(location.address),
          isDarkMode: isDarkMode,
        );
      },
    );
  }

  Widget _buildSavedAndRecentLocations(LocationViewModel viewModel, bool isDarkMode) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Saved locations
        if (viewModel.savedLocations.isNotEmpty) ...[
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
          ...viewModel.savedLocations.map((location) =>
              LocationCard(
                location: location,
                onTap: () => _selectLocation(location.address),
                isDarkMode: isDarkMode,
              )
          ),
          const Divider(height: 1, thickness: 1),
        ],

        // Recent locations
        if (viewModel.recentLocations.isNotEmpty) ...[
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
          ...viewModel.recentLocations.map((location) =>
              LocationCard(
                location: location,
                onTap: () => _selectLocation(location.address),
                isDarkMode: isDarkMode,
              )
          ),
        ],
      ],
    );
  }
}