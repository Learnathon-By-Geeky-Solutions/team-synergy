// lib/screens/service_searched/views/service_searched_list_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/service_searched/widgets/search_header_widget.dart';
import 'package:sohojogi/screens/service_searched/widgets/service_provider_card_widget.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/location/views/location_list_view.dart';

class ServiceSearchedListView extends StatefulWidget {
  final String searchQuery;
  final String currentLocation;

  const ServiceSearchedListView({
    super.key,
    required this.searchQuery,
    required this.currentLocation,
  });

  @override
  State<ServiceSearchedListView> createState() => _ServiceSearchedListViewState();
}

class _ServiceSearchedListViewState extends State<ServiceSearchedListView> {
  final List<ServiceProviderModel> _serviceProviders = [];
  bool _isLoading = true;
  bool _hasMoreData = true;
  late String _currentLocation;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.currentLocation;
    _searchController = TextEditingController(text: widget.searchQuery);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Simulate network request with delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _serviceProviders.addAll(_getDummyServiceProviders());
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (!_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network request with delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Add more data or set hasMoreData to false when reaching the end
      if (_serviceProviders.length >= 15) {
        setState(() {
          _hasMoreData = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _serviceProviders.addAll(_getDummyServiceProviders());
          _isLoading = false;
        });
      }
    }
  }

  List<ServiceProviderModel> _getDummyServiceProviders() {
    // Generate a few dummy service providers for testing
    return List.generate(
      5,
          (index) => ServiceProviderModel(
        id: 'id_${index + _serviceProviders.length}',
        name: 'Provider ${index + _serviceProviders.length + 1}',
        profileImage: 'https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${20 + index + _serviceProviders.length}.jpg',
        location: _currentLocation, // Use the current location
        serviceCategory: widget.searchQuery,
        rating: 3.5 + (index % 3) * 0.5,
        reviewCount: 50 + (index * 30),
        email: 'provider${index + _serviceProviders.length + 1}@example.com',
        phoneNumber: '+880 1${700000000 + (index + _serviceProviders.length) * 11111}',
        gender: index % 2 == 0 ? Gender.male : Gender.female,
      ),
    );
  }

  void _performNewSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _serviceProviders.clear();
        _isLoading = true;
        _hasMoreData = true;
      });

      // Simulate network request with delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _serviceProviders.addAll(_getDummyServiceProviders());
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, search bar and filter button
            Container(
              color: isDarkMode ? darkColor : lightColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top row with back button, search bar, and filter
                  Row(
                    children: [
                      // Back button
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: isDarkMode ? lightColor : darkColor,
                          ),
                        ),
                      ),

                      // Search bar
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                color: isDarkMode ? lightColor : darkColor,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search services...',
                                hintStyle: TextStyle(
                                  color: isDarkMode ? lightGrayColor : grayColor,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: isDarkMode ? lightGrayColor : grayColor,
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onSubmitted: (query) {
                                if (query.isNotEmpty) {
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
                              },
                            ),
                          ),
                        ),
                      ),

                      // Filter button
                      InkWell(
                        onTap: () => _showFilterBottomSheet(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                          ),
                          child: Icon(
                            Icons.filter_list,
                            size: 20,
                            color: isDarkMode ? lightColor : darkColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location bar
                  InkWell(
                    onTap: () async {
                      final selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LocationScreen()),
                      );

                      if (selectedLocation != null && mounted) {
                        setState(() {
                          _currentLocation = selectedLocation;
                          // Reload data with new location
                          _serviceProviders.clear();
                          _isLoading = true;
                          _hasMoreData = true;
                        });
                        _loadInitialData();
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _currentLocation,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search query display
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Showing results for "${_searchController.text}"',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? lightColor : darkColor,
                      ),
                    ),
                  ),
                ],
              ),
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
    if (_isLoading && _serviceProviders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_serviceProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDarkMode ? lightGrayColor : Colors.grey,
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
              'Try a different search or location',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? lightGrayColor : Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading && _hasMoreData) {
          _loadMoreData();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: _serviceProviders.length + (_hasMoreData ? 1 : 0),
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          if (index == _serviceProviders.length) {
            return _isLoading
                ? const Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ))
                : const SizedBox.shrink();
          }

          final provider = _serviceProviders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ServiceProviderCardWidget(
              serviceProvider: provider,
              onCardTap: () {
                // Navigate to service provider detail page
              },
              onCallTap: () {
                // Handle call action
              },
              onMailTap: () {
                // Handle mail action
              },
              onMenuTap: () {
                _showOptionsMenu(context, provider);
              },
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
            return _FilterBottomSheet(
              scrollController: scrollController,
              onApplyFilters: (filters) {
                Navigator.pop(context);
                // Apply filters logic
                setState(() {
                  _serviceProviders.clear();
                  _isLoading = true;
                });
                _loadInitialData();
              },
            );
          },
        );
      },
    );
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
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? lightGrayColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: primaryColor),
              title: const Text('Save to Bookmarks'),
              onTap: () {
                Navigator.pop(context);
                // Bookmark logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: primaryColor),
              title: const Text('Share Provider'),
              onTap: () {
                Navigator.pop(context);
                // Share logic
              },
            ),
            ListTile(
              leading: Icon(Icons.report_outlined, color: Colors.red.shade600),
              title: Text('Report Provider', style: TextStyle(color: Colors.red.shade600)),
              onTap: () {
                Navigator.pop(context);
                // Report logic
              },
            ),
          ],
        );
      },
    );
  }
}

// Add this class definition at the end of your file, after the _ServiceSearchedListViewState class
class _FilterBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onApplyFilters;

  const _FilterBottomSheet({
    required this.scrollController,
    required this.onApplyFilters,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  double _minRating = 0.0;
  List<String> _selectedCategories = [];
  String _sortBy = 'Rating';
  double _maxDistance = 10.0;

  final List<String> _availableCategories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Cleaner',
    'Painter',
    'Gardener'
  ];

  final List<String> _sortOptions = [
    'Rating',
    'Distance',
    'Price: Low to High',
    'Price: High to Low',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const Divider(),

        // Minimum Rating
        const SizedBox(height: 16),
        Text(
          'Minimum Rating',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _minRating,
                min: 0,
                max: 5,
                divisions: 10,
                label: _minRating.toString(),
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    _minRating = value;
                  });
                },
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                _minRating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        // Categories
        const SizedBox(height: 16),
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              selectedColor: primaryColor.withOpacity(0.2),
              checkmarkColor: primaryColor,
            );
          }).toList(),
        ),

        // Sort By
        const SizedBox(height: 16),
        Text(
          'Sort By',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _sortOptions.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: _sortBy == option,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _sortBy = option;
                  });
                }
              },
              selectedColor: primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ),

        // Maximum Distance
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Maximum Distance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${_maxDistance.toInt()} km',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _maxDistance,
          min: 1,
          max: 20,
          divisions: 19,
          label: '${_maxDistance.toStringAsFixed(1)} km',
          activeColor: primaryColor,
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),

        // Apply Button
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final filters = {
              'minRating': _minRating,
              'categories': _selectedCategories,
              'sortBy': _sortBy,
              'maxDistance': _maxDistance,
            };
            widget.onApplyFilters(filters);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: lightColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Apply Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() {
              _minRating = 0.0;
              _selectedCategories = [];
              _sortBy = 'Rating';
              _maxDistance = 10.0;
            });
          },
          child: const Text('Reset All'),
        ),
      ],
    );
  }
}

// Internal Filter Bottom Sheet widget remains unchanged

