import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/home/models/home_models.dart';
import 'package:sohojogi/screens/worker_profile/views/worker_profile_screen.dart';
import '../view_model/home_view_model.dart';
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
    _initAutoScroll();
  }

  void _initAutoScroll() {
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
          LocationBar(
            currentLocation: viewModel.currentLocation,
            onLocationChanged: viewModel.updateLocation,
          ),
          _buildSearchBar(context, viewModel),
          const SizedBox(height: 16),
          _buildServiceHeader(context, isDarkMode),
          _ServiceRows(
            services: viewModel.services,
            isDarkMode: isDarkMode,
            onTap: viewModel.navigateToServiceCategory,
          ),
          const SizedBox(height: 32),
          _buildBannerSection(viewModel, isDarkMode),
          const SizedBox(height: 32),
          _buildTopProvidersSection(context, viewModel, isDarkMode),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search for services...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onSubmitted: (query) => viewModel.performSearch(context, query),
      ),
    );
  }

  Widget _buildServiceHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Center(
        child: Text(
          'Services',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection(HomeViewModel viewModel, bool isDarkMode) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: viewModel.banners.length,
              onPageChanged: viewModel.setCurrentBannerPage,
              itemBuilder: (context, index) => _BannerItem(banner: viewModel.banners[index]),
            ),
          ),
        ),
        _buildPaginationDots(viewModel, isDarkMode),
      ],
    );
  }

  Widget _buildPaginationDots(HomeViewModel viewModel, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        viewModel.banners.length,
            (index) => _PaginationDot(
          isActive: viewModel.currentBannerPage == index,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  Widget _buildTopProvidersSection(BuildContext context, HomeViewModel viewModel, bool isDarkMode) {
    return Padding(
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
          _ProviderGrid(
            providers: viewModel.topProviders,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final bool isDarkMode;
  final Function(BuildContext, String) onTap;

  const _ServiceCard({
    required this.service,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => onTap(context, service.name),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? darkColor : lightColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  service.icon,
                  color: primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  service.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceRows extends StatelessWidget {
  final List<ServiceModel> services;
  final bool isDarkMode;
  final Function(BuildContext, String) onTap;

  const _ServiceRows({
    required this.services,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (services.length / 2).ceil(),
              itemBuilder: (context, index) => _ServiceCard(
                service: services[index],
                isDarkMode: isDarkMode,
                onTap: onTap,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Second row
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (services.length / 2).floor(),
              itemBuilder: (context, index) {
                final serviceIndex = index + (services.length / 2).ceil();
                return _ServiceCard(
                  service: services[serviceIndex],
                  isDarkMode: isDarkMode,
                  onTap: onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final dynamic banner;

  const _BannerItem({required this.banner});

  @override
  Widget build(BuildContext context) {
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
  }
}

class _PaginationDot extends StatelessWidget {
  final bool isActive;
  final bool isDarkMode;

  const _PaginationDot({required this.isActive, required this.isDarkMode});

  Color _getDotColor() {
    if (isActive) {
      return primaryColor;
    }
    return isDarkMode ? lightGrayColor : Colors.grey[300]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getDotColor(),
      ),
    );
  }
}

class _ProviderGrid extends StatelessWidget {
  final List<dynamic> providers;
  final bool isDarkMode;

  const _ProviderGrid({required this.providers, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) => _ProviderCard(
        provider: providers[index],
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final dynamic provider;
  final bool isDarkMode;

  const _ProviderCard({required this.provider, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: isDarkMode ? darkColor : lightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerProfileScreen(workerId: provider.id),
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
            _ProviderInfo(provider: provider, isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}

class _ProviderInfo extends StatelessWidget {
  final dynamic provider;
  final bool isDarkMode;

  const _ProviderInfo({required this.provider, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        _RatingRow(provider: provider, isDarkMode: isDarkMode),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final dynamic provider;
  final bool isDarkMode;

  const _RatingRow({required this.provider, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}