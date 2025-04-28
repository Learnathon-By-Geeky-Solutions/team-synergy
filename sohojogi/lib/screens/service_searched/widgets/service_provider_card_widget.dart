import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import '../../worker_profile/views/worker_profile_screen.dart';

class ServiceProviderCardWidget extends StatelessWidget {
  final ServiceProviderModel serviceProvider;
  final VoidCallback onCardTap;
  final VoidCallback onCallTap;
  final VoidCallback onMailTap;
  final VoidCallback onMenuTap;

  const ServiceProviderCardWidget({
    super.key,
    required this.serviceProvider,
    required this.onCardTap,
    required this.onCallTap,
    required this.onMailTap,
    required this.onMenuTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final dividerColor = isDarkMode ? lightGrayColor.withValues(alpha: 0.3) : Colors.grey.shade300;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? darkColor : lightColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _navigateToWorkerProfile(context),
        borderRadius: BorderRadius.circular(16),
        child: _buildCardContent(context, isDarkMode, dividerColor),
      ),
    );
  }

  void _navigateToWorkerProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkerProfileScreen(
          workerId: serviceProvider.id,
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isDarkMode, Color dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildHeader(context, isDarkMode),
        ),
        Divider(height: 1, thickness: 1, color: dividerColor),
        _buildContactInfo(context, isDarkMode),
        _buildActionButtons(isDarkMode, dividerColor),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfilePicture(),
        const SizedBox(width: 12),
        Expanded(
          child: _buildProviderInfo(context, isDarkMode),
        ),
        _buildMenuButton(isDarkMode),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(serviceProvider.profileImage),
        ),
      ),
    );
  }

  Widget _buildProviderInfo(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameAndGender(context, isDarkMode),
        _buildLocation(context, isDarkMode),
        const SizedBox(height: 8),
        _buildServiceCategory(),
        const SizedBox(height: 8),
        _buildRatingInfo(context, isDarkMode),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? lightColor.withValues(alpha: 0.9)
        : darkColor.withValues(alpha: 0.9);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactRow(
            icon: Icons.email_outlined,
            text: serviceProvider.email,
            isDarkMode: isDarkMode,
            textColor: textColor,
            context: context,
          ),
          const SizedBox(height: 10),
          _buildContactRow(
            icon: Icons.phone_outlined,
            text: serviceProvider.phoneNumber,
            isDarkMode: isDarkMode,
            textColor: textColor,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode, Color dividerColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: _buildActionButtonRow(dividerColor),
    );
  }

  Widget _buildMenuButton(bool isDarkMode) {
    return IconButton(
      onPressed: onMenuTap,
      icon: Icon(
        Icons.more_vert,
        color: isDarkMode ? lightColor : darkColor,
      ),
    );
  }

  Widget _buildNameAndGender(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Text(
            serviceProvider.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        _getGenderIcon(),
      ],
    );
  }

  Widget _buildLocation(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            serviceProvider.location,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCategory() {
    final List<String> categoryList = serviceProvider.categories.isEmpty
        ? [serviceProvider.serviceCategory]
        : serviceProvider.categories;

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: categoryList.map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingInfo(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        _buildRatingStars(serviceProvider.rating),
        const SizedBox(width: 8),
        Text(
          '(${serviceProvider.reviewCount})', // Changed from totalReviews to reviewCount
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
    required Color textColor,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonRow(Color dividerColor) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: onMailTap,
            icon: const Icon(Icons.email_outlined, size: 20),
            label: const Text('Email'),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        VerticalDivider(width: 1, thickness: 1, color: dividerColor),
        Expanded(
          child: TextButton.icon(
            onPressed: onCallTap,
            icon: const Icon(Icons.phone_outlined, size: 20),
            label: const Text('Call'),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Icon _getGenderIcon() {
    switch (serviceProvider.gender) {
      case Gender.male:
        return const Icon(Icons.male, size: 16, color: Colors.blue);
      case Gender.female:
        return const Icon(Icons.female, size: 16, color: Colors.pink);
      default:
        return const Icon(Icons.transgender, size: 16, color: Colors.pink);
    }
  }


  Widget _buildRatingStars(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.amber);
        }
      }),
    );
  }

}