import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../view_model/location_view_model.dart';
import '../widgets/location_card.dart';
import '../widgets/location_search_header.dart';
import 'location_selector_view.dart';

class LocationListView extends StatefulWidget {
  const LocationListView({super.key});

  @override
  State<LocationListView> createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationViewModel>(context, listen: false).init();
    });

    _searchController.addListener(() {
      Provider.of<LocationViewModel>(context, listen: false)
          .search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocationViewModel>(context);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LocationSearchHeader(
            searchController: _searchController,
            useCurrentLocation: () async {
              final location = await viewModel.useCurrentLocation();
              if (location != null && mounted) {
                navigator.pop(location.address);
              }
            },
            chooseOnMap: () {},
            isDarkMode: isDarkMode,
          ),

          // Main content (search results or locations list)
          Expanded(
            child: _buildMainContent(viewModel, isDarkMode),
          ),

          // Add new location button at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                final navigator = Navigator.of(context);
                Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (context) => const LocationSelectorView()),
                ).then((result) {
                  if (result != null && mounted) {
                    navigator.pop(result);
                  }
                });
              },
              icon: const Icon(Icons.add_location_alt, size: 18),
              label: const Text('Add New Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Use theme color
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    return _buildLocationsList(viewModel, isDarkMode);
  }

  Widget _buildLocationsList(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.isSearching) {
      return _buildSearchResults(viewModel, isDarkMode);
    }

    return ListView(
      children: [
        // Saved locations section
        if (viewModel.savedLocations.isNotEmpty) ...[
          _buildSectionHeader('Saved Locations', isDarkMode),
          ...viewModel.savedLocations.map((location) => LocationCard(
            location: location,
            onTap: () => Navigator.pop(context, location.address),
            isDarkMode: isDarkMode,
          )),
        ],

        // Recent locations section
        if (viewModel.recentLocations.isNotEmpty) ...[
          _buildSectionHeader('Recent Locations', isDarkMode),
          ...viewModel.recentLocations.map((location) => LocationCard(
            location: location,
            onTap: () => Navigator.pop(context, location.address),
            isDarkMode: isDarkMode,
          )),
        ],

        // Empty state message
        if (viewModel.savedLocations.isEmpty && viewModel.recentLocations.isEmpty)
          _buildEmptyState(isDarkMode),
      ],
    );
  }

  Widget _buildSearchResults(LocationViewModel viewModel, bool isDarkMode) {
    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Text(
          'No locations found',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }

    return ListView(
      children: viewModel.searchResults.map((location) => LocationCard(
        location: location,
        onTap: () => Navigator.pop(context, location.address),
        isDarkMode: isDarkMode,
      )).toList(),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: isDarkMode ? Colors.white30 : Colors.black26,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new location or use your current location',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}