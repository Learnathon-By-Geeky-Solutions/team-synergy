import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final WorkerProfileModel worker;
  final bool isBookmarked;
  final VoidCallback onBackPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;

  const ProfileHeaderWidget({
    super.key,
    required this.worker,
    required this.isBookmarked,
    required this.onBackPressed,
    required this.onBookmarkPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Extracted color logic
    final Color backButtonColor = isDarkMode
        ? grayColor.withValues(alpha: 0.3)
        : Colors.grey.shade200;

    return Container(
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
                  onTap: onBackPressed,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backButtonColor, // Use the extracted variable
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

              // Action buttons
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBookmarkPressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? grayColor.withValues(alpha: 0.3) : Colors.grey.shade200,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 20,
                          color: isBookmarked ? primaryColor : (isDarkMode ? lightColor : darkColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onSharePressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.share,
                          size: 20,
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
