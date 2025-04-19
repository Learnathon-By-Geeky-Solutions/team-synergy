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
    return ListTile(
      onTap: onTap,
      tileColor: isDarkMode ? darkColor : lightColor,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (location.isSaved ? primaryColor : Colors.grey).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          location.icon ?? (location.isSaved ? Icons.star : Icons.history),
          color: location.isSaved ? primaryColor : (isDarkMode ? lightGrayColor : grayColor),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
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
        location.address,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDarkMode ? lightColor : darkColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        location.name != null ? location.address : location.subAddress,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? lightGrayColor : grayColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}