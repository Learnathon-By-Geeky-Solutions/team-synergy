import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';

import '../view_model/location_view_model.dart';

class LocationSearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback useCurrentLocation;
  final VoidCallback chooseOnMap;
  final bool isDarkMode;

  const LocationSearchHeader({
    super.key,
    required this.searchController,
    required this.useCurrentLocation,
    required this.chooseOnMap,
    required this.isDarkMode,
  });

  void _handleMapSelection(BuildContext context) {
    // Capture dependencies before async gap
    final navigator = Navigator.of(context);
    final viewModel = Provider.of<LocationViewModel>(context, listen: false);

    viewModel.navigateToMapSelector(context).then((selectedLocation) {
      if (selectedLocation != null) {
        navigator.pop(selectedLocation.address);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildActionButtons(context),
        _buildDivider(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: searchController,
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
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildCurrentLocationButton(),
          const SizedBox(height: 12),
          _buildMapSelectorButton(context),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationButton() {
    return OutlinedButton.icon(
      onPressed: useCurrentLocation,
      icon: const Icon(Icons.my_location, color: primaryColor, size: 18),
      label: const Text(
        'Use current location',
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }

  Widget _buildMapSelectorButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _handleMapSelection(context),
      icon: const Icon(Icons.map, color: secondaryColor, size: 18),
      label: const Text(
        'Choose on map',
        style: TextStyle(color: secondaryColor, fontWeight: FontWeight.w500),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: secondaryColor),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 8,
      color: isDarkMode ? grayColor : Colors.grey[100],
    );
  }
}