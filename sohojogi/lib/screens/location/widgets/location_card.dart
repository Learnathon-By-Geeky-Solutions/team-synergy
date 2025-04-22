import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import '../models/location_model.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final bool isDarkMode;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final tileBackgroundColor = isDarkMode ? darkColor : lightColor;

    final iconColor = location.isSaved
        ? primaryColor
        : (isDarkMode ? lightGrayColor : grayColor);

    final titleText = location.name ?? location.address;

    final subtitleText = location.name != null
        ? location.address
        : location.subAddress;

    final leadingIcon = location.icon != null
        ? location.icon
        : (location.isSaved ? Icons.star : Icons.history);

    final leadingBackgroundColor = (location.isSaved ? primaryColor : Colors.grey)
        .withValues(alpha: 0.2);

    return ListTile(
      onTap: onTap,
      tileColor: tileBackgroundColor,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: leadingBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          leadingIcon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: location.name != null
          ? Row(
        children: [
          Text(
            location.name!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          if (location.isSaved) ...[
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Saved',
                style: TextStyle(
                  fontSize: 10,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      )
          : Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDarkMode ? lightColor : darkColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitleText,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
