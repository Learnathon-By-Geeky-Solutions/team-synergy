// lib/screens/worker_profile/widgets/profile_overview_widget.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class ProfileOverviewWidget extends StatelessWidget {
  final WorkerProfileModel worker;

  const ProfileOverviewWidget({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Image with Verification Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    worker.profileImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (worker.isVerified)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? darkColor : lightColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating and Review Count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 22,
              ),
              const SizedBox(width: 4),
              Text(
                worker.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${worker.reviewCount})',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
              const SizedBox(width: 4),
              Text(
                worker.location,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Service Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              worker.serviceCategory,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.work_outline,
                value: '${worker.yearsOfExperience}+',
                label: 'Years',
                isDarkMode: isDarkMode,
              ),
              _buildStatItem(
                icon: Icons.check_circle_outline,
                value: worker.jobsCompleted.toString(),
                label: 'Jobs',
                isDarkMode: isDarkMode,
              ),
              _buildStatItem(
                icon: Icons.trending_up,
                value: '${worker.completionRate.toStringAsFixed(1)}%',
                label: 'Success',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
        ),
      ],
    );
  }
}