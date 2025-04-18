// lib/screens/service_searched/views/service_searched_list_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/service_searched/widgets/search_header_widget.dart';
import 'package:sohojogi/screens/service_searched/widgets/service_provider_card_widget.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';

class ServiceSearchedListView extends StatefulWidget {
  final String searchQuery;

  const ServiceSearchedListView({
    super.key,
    this.searchQuery = 'Demo Service'
  });

  @override
  State<ServiceSearchedListView> createState() => _ServiceSearchedListViewState();
}

class _ServiceSearchedListViewState extends State<ServiceSearchedListView> {
  final List<ServiceProviderModel> _serviceProviders = [];
  bool _isLoading = true;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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
        name: 'John Doe ${index + _serviceProviders.length}',
        profileImage: 'https://randomuser.me/api/portraits/men/${(index + _serviceProviders.length) % 100}.jpg',
        location: 'Austin, TX',
        serviceCategory: widget.searchQuery,
        rating: 4.3 + (index * 0.1) % 0.7,
        reviewCount: 243 + index * 12,
        email: 'johndoe${index + _serviceProviders.length}@example.com',
        phoneNumber: '+1 123 456 ${7890 + index}',
        gender: index % 3 == 0 ? Gender.female : Gender.male,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Search header with back button, logo, location and search bar
            SearchHeaderWidget(
              searchQuery: widget.searchQuery,
              onFilterTap: () {
                _showFilterBottomSheet(context);
              },
              onBackTap: () {
                Navigator.pop(context);
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
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No service providers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try with a different search term',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && _hasMoreData) {
          _loadMoreData();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _serviceProviders.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _serviceProviders.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ServiceProviderCardWidget(
              serviceProvider: _serviceProviders[index],
              onCardTap: () {
                // Navigate to service provider detail page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Viewing ${_serviceProviders[index].name}\'s profile'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onCallTap: () {
                // Launch phone call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${_serviceProviders[index].phoneNumber}'),
                  ),
                );
              },
              onMailTap: () {
                // Launch email
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Emailing ${_serviceProviders[index].email}'),
                  ),
                );
              },
              onMenuTap: () {
                _showOptionsMenu(context, _serviceProviders[index]);
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return _FilterBottomSheet(
              scrollController: scrollController,
              onApplyFilters: (Map<String, dynamic> filters) {
                // Apply filters to the search results
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filters applied')),
                );
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.bookmark_border),
                  title: const Text('Save to bookmarks'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${provider.name} saved to bookmarks')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share profile'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report_outlined),
                  title: const Text('Report this profile'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Block'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Internal Filter Bottom Sheet widget
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _minRating = 0.0;
                  _selectedCategories = [];
                  _sortBy = 'Rating';
                  _maxDistance = 10.0;
                });
              },
              child: const Text('Reset'),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
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
              selectedColor: primaryColor.withOpacity(0.2),
              checkmarkColor: primaryColor,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
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
              selectedColor: primaryColor.withOpacity(0.2),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _sortBy = option;
                  });
                }
              },
            );
          }).toList(),
        ),

        // Distance
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Maximum Distance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${_maxDistance.toStringAsFixed(1)} km',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _maxDistance,
          min: 1,
          max: 50,
          divisions: 49,
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
            widget.onApplyFilters({
              'minRating': _minRating,
              'categories': _selectedCategories,
              'sortBy': _sortBy,
              'maxDistance': _maxDistance,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: lightColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Apply Filters'),
        ),
      ],
    );
  }
}