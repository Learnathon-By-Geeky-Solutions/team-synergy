import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/service_searched/widgets/search_header_widget.dart';
import 'package:sohojogi/screens/service_searched/widgets/service_provider_card_widget.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/service_searched/view_model/service_searched_view_model.dart';
import 'package:sohojogi/screens/location/views/location_list_view.dart';
import 'package:sohojogi/screens/service_searched/widgets/filter_bottom_sheet.dart';

class ServiceSearchedListView extends StatefulWidget {
  final String searchQuery;
  final double latitude;
  final double longitude;
  final String location;

  const ServiceSearchedListView({
    super.key,
    required this.searchQuery,
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  @override
  State<ServiceSearchedListView> createState() => _ServiceSearchedListViewState();
}

class _ServiceSearchedListViewState extends State<ServiceSearchedListView> {
  late TextEditingController _searchController;

  @override
  void _clearFilters(BuildContext context) {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context, listen: false);

    // Apply an empty filter map (effectively resetting filters)
    viewModel.applyFilters(
      {}, // Empty filters
      widget.searchQuery,
      widget.latitude,
      widget.longitude,
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);

    // Initialize and load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context, listen: false);

    // Initialize categories
    await viewModel.init();

    // Perform initial search
    await viewModel.searchServiceProviders(
      searchQuery: widget.searchQuery,
      userLatitude: widget.latitude,
      userLongitude: widget.longitude,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context);
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Using SearchHeaderWidget with the search bar
            SearchHeaderWidget(
              searchQuery: widget.searchQuery,
              currentLocation: widget.location,
              onFilterTap: () => _showFilterBottomSheet(context),
              onBackTap: () => Navigator.pop(context),
              onLocationTap: () => _selectLocation(context),
              searchController: _searchController,
              onSearchSubmitted: (query) {
                viewModel.searchServiceProviders(
                  searchQuery: query,
                  userLatitude: widget.latitude,
                  userLongitude: widget.longitude,
                  filters: viewModel.currentFilters,
                );
              },
            ),

            // Search results list
            Expanded(
              child: _buildSearchResultsList(isDarkMode),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavBar(),
    );
  }

  Widget _buildSearchResultsList(bool isDarkMode) {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context);

    if (viewModel.isLoading && viewModel.serviceProviders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: lightColor,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.serviceProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No service providers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Remove pagination since hasMoreData and loadMoreData aren't implemented
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !viewModel.isLoading) {
          // Could add refreshing functionality here if needed
        }
        return true;
      },
      child: ListView.builder(
        itemCount: viewModel.serviceProviders.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final provider = viewModel.serviceProviders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ServiceProviderCardWidget(
              serviceProvider: provider,
              onCardTap: () {
                // Navigate to provider detail
              },
              onCallTap: () {
                // Handle call action
              },
              onMailTap: () {
                // Handle mail action
              },
              onMenuTap: () => _showOptionsMenu(context, provider),
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, controller) {
            return FilterBottomSheetWidget(
              availableCategories: viewModel.availableCategories,
              initialFilters: viewModel.currentFilters,
              onApplyFilters: (filters) {
                viewModel.applyFilters(
                  filters,
                  widget.searchQuery,
                  widget.latitude,
                  widget.longitude,
                );
              },
            );
          },
        );
      },
    );
  }

  void _selectLocation(BuildContext context) async {
    final viewModel = Provider.of<ServiceSearchedViewModel>(context, listen: false);

    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationListView()),
    );

    if (selectedLocation != null && selectedLocation is Map<String, dynamic>) {
      // Instead of calling setLocation which doesn't exist,
      // use the existing searchServiceProviders method with the new location
      await viewModel.searchServiceProviders(
        searchQuery: widget.searchQuery,
        userLatitude: selectedLocation['latitude'] ?? widget.latitude,
        userLongitude: selectedLocation['longitude'] ?? widget.longitude,
        filters: viewModel.currentFilters,
      );

      // You may need to update the UI state to show the new location
      // This would typically be handled in a more comprehensive solution
    }
  }

  void _showOptionsMenu(BuildContext context, ServiceProviderModel provider) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? darkColor : lightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_outline, color: primaryColor),
              title: Text('Save to Bookmarks',
                  style: TextStyle(color: isDarkMode ? lightColor : darkColor)),
              onTap: () {
                Navigator.pop(context);
                // Implement bookmark functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to bookmarks')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.redAccent),
              title: Text('Block This Provider',
                  style: TextStyle(color: isDarkMode ? lightColor : darkColor)),
              onTap: () {
                Navigator.pop(context);
                // Implement block functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Provider blocked')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: Text('Report Provider',
                  style: TextStyle(color: isDarkMode ? lightColor : darkColor)),
              onTap: () {
                Navigator.pop(context);
                // Implement report functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}