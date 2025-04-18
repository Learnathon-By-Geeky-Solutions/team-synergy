import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/views/service_searched_list_view.dart';
import 'package:sohojogi/screens/location/views/location_list_view.dart';

class HomeBodyContent extends StatefulWidget {
  const HomeBodyContent({super.key});

  @override
  State<HomeBodyContent> createState() => _HomeBodyContentState();
}

class _HomeBodyContentState extends State<HomeBodyContent> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;
  String _currentLocation = 'Mirpur 10, Dhaka';

  final List<Map<String, dynamic>> _banners = [
    {'title': 'CASHON Insurance', 'color': primaryColor},
    {'title': 'Family Coverage Plan', 'color': secondaryColor},
    {'title': 'Premium Protection', 'color': Color(0xFF4CAF50)},
  ];

  final List<Map<String, dynamic>> _services = [
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Repairing', 'icon': Icons.build},
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Carpenter', 'icon': Icons.handyman},
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Painting', 'icon': Icons.format_paint},
    {'name': 'Gardening', 'icon': Icons.grass},
    {'name': 'Moving', 'icon': Icons.local_shipping},
    {'name': 'Laundry', 'icon': Icons.local_laundry_service},
    {'name': 'Cooking', 'icon': Icons.restaurant},
    {'name': 'Delivery', 'icon': Icons.delivery_dining},
    {'name': 'Tutoring', 'icon': Icons.school},
  ];

  final List<Map<String, dynamic>> _topProviders = [
    {
      'name': 'John Doe',
      'service': 'Plumbing',
      'rating': 4.9,
      'reviews': 253,
      'image': 'https://randomuser.me/api/portraits/men/32.jpg'
    },
    {
      'name': 'Sarah Smith',
      'service': 'Cleaning',
      'rating': 4.8,
      'reviews': 187,
      'image': 'https://randomuser.me/api/portraits/women/44.jpg'
    },
    {
      'name': 'David Wilson',
      'service': 'Electrician',
      'rating': 4.7,
      'reviews': 129,
      'image': 'https://randomuser.me/api/portraits/men/56.jpg'
    },
    {
      'name': 'Emma Johnson',
      'service': 'Tutoring',
      'rating': 4.9,
      'reviews': 201,
      'image': 'https://randomuser.me/api/portraits/women/33.jpg'
    },
    {
      'name': 'Michael Brown',
      'service': 'Carpenter',
      'rating': 4.6,
      'reviews': 142,
      'image': 'https://randomuser.me/api/portraits/men/78.jpg'
    },
    {
      'name': 'Lisa Garcia',
      'service': 'Gardening',
      'rating': 4.7,
      'reviews': 118,
      'image': 'https://randomuser.me/api/portraits/women/65.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();

    // Auto-scroll banner
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_bannerController.hasClients) {
        if (_currentBannerPage < _banners.length - 1) {
          _currentBannerPage++;
        } else {
          _currentBannerPage = 0;
        }

        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDarkMode ? grayColor : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Bar
          InkWell(
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationScreen()),
              );

              if (selectedLocation != null && mounted) {
                setState(() {
                  _currentLocation = selectedLocation;
                });
              }
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: isDarkMode ? darkColor : lightColor,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentLocation,  // Use the state variable instead of hardcoded text

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? darkColor : lightColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services',
                  prefixIcon: Icon(Icons.search, color: isDarkMode ? lightColor : darkColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: TextStyle(color: isDarkMode ? lightGrayColor : grayColor),
                ),
                style: TextStyle(color: isDarkMode ? lightColor : darkColor),
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceSearchedListView(
                          searchQuery: query,
                          currentLocation: _currentLocation, // Added the missing parameter
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          // Added extra spacing between search bar and services section
          const SizedBox(height: 16),

          // Services Section with Horizontally Scrollable Grid (2 rows)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Centered Services title
                Center(
                  child: Text(
                    'Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220, // Fixed height for 2 rows
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 rows
                      childAspectRatio: 0.9, // Adjusted for horizontal layout
                      crossAxisSpacing: 16, // Spacing between rows
                      mainAxisSpacing: 16, // Spacing between columns
                    ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailPage(service: _services[index]['name']),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          color: isDarkMode ? darkColor : lightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _services[index]['icon'],
                                size: 40,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _services[index]['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode ? lightColor : darkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Additional spacing between services and banner
          const SizedBox(height: 32),

          // Banner Carousel
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: _banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle banner tap
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${_banners[index]['title']}')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            _banners[index]['color'],
                            _banners[index]['color'].withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 20,
                            top: 20,
                            child: Icon(
                              Icons.shield,
                              size: 60,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          Center(
                            child: Text(
                              _banners[index]['title'],
                              style: const TextStyle(
                                color: lightColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Pagination Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBannerPage == index
                      ? primaryColor
                      : (isDarkMode ? lightGrayColor : Colors.grey[300]),
                ),
              );
            }),
          ),

          // Space before top rated providers section
          const SizedBox(height: 32),

          // Top Rated Service Providers Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Section title
                Center(
                  child: Text(
                    'Top Providers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Grid of top providers (2 columns, vertical scroll)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _topProviders.length,
                  itemBuilder: (context, index) {
                    final provider = _topProviders[index];
                    return Card(
                      elevation: 2,
                      color: isDarkMode ? darkColor : lightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Viewing ${provider['name']}\'s profile')),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            // Profile image
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(provider['image']),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 12),
                            // Name
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                provider['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? lightColor : darkColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Service
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                provider['service'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  "${provider['rating']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? lightColor : darkColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${provider['reviews']})",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode ? lightGrayColor : grayColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Only keep the ServiceDetailPage and remove the conflicting LocationScreen class
class ServiceDetailPage extends StatelessWidget {
  final String service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service)),
      body: Center(child: Text('$service service details')),
    );
  }
}