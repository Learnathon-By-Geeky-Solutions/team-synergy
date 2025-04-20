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
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final dividerColor = isDarkMode ? lightGrayColor.withOpacity(0.3) : Colors.grey.shade300;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? darkColor : lightColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerProfileScreen(
                  workerId: serviceProvider.id,
                ),
              ),
            );
          },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with profile picture, gender icon, name, and menu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture

                  GestureDetector(
                    onTap: onCardTap,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                  ),
                  const SizedBox(width: 12),

                  // Name and other details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and gender icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                serviceProvider.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? lightColor : darkColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              serviceProvider.gender == Gender.male
                                  ? Icons.male
                                  : serviceProvider.gender == Gender.female
                                  ? Icons.female
                                  : Icons.transgender,
                              size: 16,
                              color: serviceProvider.gender == Gender.male
                                  ? Colors.blue
                                  : Colors.pink,
                            ),
                          ],
                        ),

                        // Location
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: isDarkMode ? lightGrayColor : grayColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  serviceProvider.location,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode ? lightGrayColor : grayColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Service category
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            serviceProvider.serviceCategory,
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Rating
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              serviceProvider.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? lightColor : darkColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            _buildRatingStars(serviceProvider.rating),
                            const SizedBox(width: 4),
                            Text(
                              '(${serviceProvider.reviewCount})',
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

                  // Menu button
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                      onPressed: onMenuTap,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: dividerColor),

            // Contact information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serviceProvider.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? lightColor.withOpacity(0.9) : darkColor.withOpacity(0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Phone
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serviceProvider.phoneNumber,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? lightColor.withOpacity(0.9) : darkColor.withOpacity(0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onCallTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Call',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: dividerColor,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onMailTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Email',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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