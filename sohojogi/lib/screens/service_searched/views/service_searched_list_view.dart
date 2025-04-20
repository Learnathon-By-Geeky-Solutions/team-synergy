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

class ServiceSearchedListView extends StatelessWidget {
  final String searchQuery;
  final String currentLocation;

  const ServiceSearchedListView({
    super.key,
    required this.searchQuery,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = ServiceSearchedViewModel();
        viewModel.initialize(searchQuery, currentLocation);
        return viewModel;
      },
      child: const _ServiceSearchedListContent(),
    );
  }
}

class _ServiceSearchedListContent extends StatefulWidget {
  const _ServiceSearchedListContent();

  @override
  State<_ServiceSearchedListContent> createState() => _ServiceSearchedListContentState();
}

class _ServiceSearchedListContentState extends State<_ServiceSearchedListContent> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
        text: Provider.of<ServiceSearchedViewModel>(context, listen: false).searchQuery
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
              searchQuery: viewModel.searchQuery,
              currentLocation: viewModel.currentLocation,
              onFilterTap: () => _showFilterBottomSheet(context),
              onBackTap: () => Navigator.pop(context),
              onLocationTap: () => _selectLocation(context),
              searchController: _searchController,
              onSearchSubmitted: (query) {
                viewModel.setSearchQuery(query);
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
        child: CircularProgressIndicator(),
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
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !viewModel.isLoading && viewModel.hasMoreData) {
          viewModel.loadMoreData();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: viewModel.serviceProviders.length + (viewModel.hasMoreData ? 1 : 0),
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          if (index == viewModel.serviceProviders.length) {
            return viewModel.isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink();
          }

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return FilterBottomSheet(
              scrollController: scrollController,
              initialFilters: viewModel.filters,
              onApplyFilters: (filters) {
                viewModel.applyFilters(filters);
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

    if (selectedLocation != null) {
      viewModel.setLocation(selectedLocation);
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
              leading: const Icon(Icons.bookmark_outline),
              title: const Text('Save to Bookmarks'),
              onTap: () {
                Navigator.pop(context);
                // Handle bookmark action
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block This Provider'),
              onTap: () {
                Navigator.pop(context);
                // Handle block action
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report Provider'),
              onTap: () {
                Navigator.pop(context);
                // Handle report action
              },
            ),
          ],
        );
      },
    );
  }
}