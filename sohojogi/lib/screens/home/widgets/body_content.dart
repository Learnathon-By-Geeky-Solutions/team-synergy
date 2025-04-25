import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/views/service_searched_list_view.dart';
import 'package:sohojogi/screens/worker_profile/views/worker_profile_screen.dart';
import '../view_model/home_view_model.dart';
import '../views/service_detail_page.dart';
import '../widgets/location_bar.dart';

class HomeBodyContent extends StatefulWidget {
  const HomeBodyContent({super.key});

  @override
  State<HomeBodyContent> createState() => _HomeBodyContentState();
}

class _HomeBodyContentState extends State<HomeBodyContent> {
  final PageController _bannerController = PageController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();

    // Auto-scroll banner
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      if (_bannerController.hasClients) {
        int nextPage = viewModel.currentBannerPage < viewModel.banners.length - 1
            ? viewModel.currentBannerPage + 1
            : 0;

        viewModel.setCurrentBannerPage(nextPage);
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDarkMode ? grayColor : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Bar
          LocationBar(
            currentLocation: viewModel.currentLocation,
            onLocationChanged: viewModel.updateLocation,
          ),

          // Search bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for services...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (query) {
                viewModel.performSearch(context, query);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Services Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Services',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all services page
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                viewModel.isLoading
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                    : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: viewModel.services.length,
                  itemBuilder: (context, index) {
                    final service = viewModel.services[index];
                    return GestureDetector(
                      onTap: () {
                        viewModel.navigateToServiceCategory(context, service.name);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(service.icon, color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.name,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Banner Carousel
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: viewModel.banners.length,
                onPageChanged: (index) {
                  viewModel.setCurrentBannerPage(index);
                },
                itemBuilder: (context, index) {
                  final banner = viewModel.banners[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${banner.title}')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            banner.color,
                            banner.color.withValues(alpha: 0.7),
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
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          Center(
                            child: Text(
                              banner.title,
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
            children: List.generate(viewModel.banners.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: viewModel.currentBannerPage == index
                      ? primaryColor
                      : (isDarkMode ? lightGrayColor : Colors.grey[300]),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // Top Rated Service Providers Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
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

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: viewModel.topProviders.length,
                  itemBuilder: (context, index) {
                    final provider = viewModel.topProviders[index];
                    return Card(
                      elevation: 2,
                      color: isDarkMode ? darkColor : lightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkerProfileScreen(
                                workerId: provider.id,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(provider.image),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                provider.name,
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                provider.service,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, size: 16, color: primaryColor),
                                const SizedBox(width: 4),
                                Text(
                                  "${provider.rating}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? lightColor : darkColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${provider.reviews})",
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