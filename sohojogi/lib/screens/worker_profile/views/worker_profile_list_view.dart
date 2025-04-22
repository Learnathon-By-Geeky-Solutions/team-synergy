import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/view_model/worker_profile_view_model.dart';
import 'package:sohojogi/screens/worker_profile/widgets/about_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/action_buttons_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/availability_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/credentials_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/portfolio_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_header_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/profile_overview_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/rating_breakdown_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/reviews_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/services_section_widget.dart';
import 'package:sohojogi/screens/worker_profile/widgets/skills_section_widget.dart';

class WorkerProfileListView extends StatefulWidget {
  final String workerId;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const WorkerProfileListView({
    super.key,
    required this.workerId,
    required this.onBackPressed,
    required this.onSharePressed,
  });

  @override
  State<WorkerProfileListView> createState() => _WorkerProfileListViewState();
}

class _WorkerProfileListViewState extends State<WorkerProfileListView> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingHeader = false;

  @override
  void initState() {
    super.initState();
    // Load worker profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerProfileViewModel>().loadWorkerProfile(widget.workerId);
    });

    // Set up scroll listener for floating header
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Show floating header after scrolling past profile overview
    if (_scrollController.hasClients) {
      setState(() {
        _showFloatingHeader = _scrollController.offset > 220;
      });
    }

    // Load more reviews when reaching end of list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final viewModel = context.read<WorkerProfileViewModel>();
      if (viewModel.hasMoreReviews && !viewModel.isLoadingMoreReviews) {
        viewModel.loadMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final viewModel = context.watch<WorkerProfileViewModel>();
    final worker = viewModel.workerProfile;

    if (viewModel.isLoading) {
      return _buildLoadingState(isDarkMode);
    }

    if (viewModel.hasError) {
      return _buildErrorState(isDarkMode, viewModel.errorMessage);
    }

    if (worker == null) {
      return _buildErrorState(
          isDarkMode,
          'Worker profile not found. Please try again.'
      );
    }

    return Stack(
      children: [
        // Main scrollable content
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Main content

            const SliverPadding(
              padding: EdgeInsets.only(top: 80), // Adjust this value based on your header height
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Profile overview section with image and basic info
                  ProfileOverviewWidget(worker: worker),

                  // Hire, call, message buttons
                  ActionButtonsWidget(
                    worker: worker,
                    hirePending: viewModel.hirePending,
                    onHirePressed: () async {
                      final success = await viewModel.initiateHiring();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hire request sent successfully!'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      }
                    },
                  ),

                  // About section with bio
                  AboutSectionWidget(bio: worker.bio),

                  // Services offered section
                  ServicesSectionWidget(services: worker.services),

                  // Skills section
                  SkillsSectionWidget(skills: worker.skills),

                  // Availability section with weekly schedule
                  AvailabilitySectionWidget(availability: worker.availability),

                  // Portfolio section
                  if (worker.portfolioItems.isNotEmpty)
                    PortfolioSectionWidget(
                      portfolioItems: worker.portfolioItems,
                      selectedIndex: viewModel.selectedPortfolioIndex,
                      onItemSelected: viewModel.selectPortfolioItem,
                    ),

                  // Credentials section
                  if (worker.qualifications.isNotEmpty)
                    CredentialsSectionWidget(
                      qualifications: worker.qualifications,
                    ),

                  // Reviews section with breakdown
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    color: isDarkMode ? darkColor : lightColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ratings & Reviews',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? lightColor : darkColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rating breakdown visualization
                        if (viewModel.ratingBreakdown != null)
                          RatingBreakdownWidget(
                            ratingBreakdown: viewModel.ratingBreakdown!,
                            overallRating: worker.rating,
                          ),

                        const SizedBox(height: 16),

                        // Reviews list with pagination
                        ReviewsSectionWidget(
                          reviews: viewModel.paginatedReviews,
                          isLoadingMore: viewModel.isLoadingMoreReviews,
                          hasMoreReviews: viewModel.hasMoreReviews,
                        ),
                      ],
                    ),
                  ),

                  // Bottom padding for safe area
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),

        // Static header at top
        ProfileHeaderWidget(
          worker: worker,
          isBookmarked: viewModel.isBookmarked,
          onBackPressed: widget.onBackPressed,
          onBookmarkPressed: viewModel.toggleBookmark,
          onSharePressed: widget.onSharePressed,
        ),

        // Floating header that appears on scroll
        if (_showFloatingHeader)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildFloatingHeader(worker, isDarkMode, viewModel),
          ),
      ],
    );
  }

  Widget _buildFloatingHeader(
      worker,
      bool isDarkMode,
      WorkerProfileViewModel viewModel
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDarkMode
          ? darkColor.withValues(alpha: 0.95)
          : lightColor.withValues(alpha: 0.95),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode ? lightColor : darkColor,
              ),
              onPressed: widget.onBackPressed,
            ),

            // Worker image
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(worker.profileImage),
            ),

            const SizedBox(width: 8),

            // Worker name and rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    worker.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        ' ${worker.rating.toStringAsFixed(1)} (${worker.reviewCount})',
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

            // Action buttons
            IconButton(
              icon: Icon(
                viewModel.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: viewModel.isBookmarked
                    ? primaryColor
                    : (isDarkMode ? lightColor : darkColor),
              ),
              onPressed: viewModel.toggleBookmark,
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: isDarkMode ? lightColor : darkColor,
              ),
              onPressed: widget.onSharePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Column(
      children: [
        // Static header at top
        Container(
          color: isDarkMode ? darkColor : lightColor,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onBackPressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Worker Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),

                  // Empty space to balance layout
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),

        // Loading indicator
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading profile...',
                  style: TextStyle(
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(bool isDarkMode, String errorMessage) {
    return Column(
      children: [
        // Static header at top
        Container(
          color: isDarkMode ? darkColor : lightColor,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onBackPressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Worker Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),

                  // Empty space to balance layout
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),

        // Error message and retry button
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
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
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode ? lightColor : darkColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkerProfileViewModel>().loadWorkerProfile(widget.workerId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: lightColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}