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

  // Map string icon keys to IconData
  IconData _getIconData(String? iconKey) {
    final Map<String, IconData> iconMap = {
      'home': Icons.home,
      'work': Icons.work,
      'favorite': Icons.favorite,
      'store': Icons.store,
      'location': Icons.location_on,
    };

    return iconMap[iconKey] ?? _getDefaultIcon();
  }

  IconData _getDefaultIcon() {
    return location.isSaved ? Icons.bookmark : Icons.history;
  }

  Color _getBackgroundColor() {
    if (isDarkMode) {
      return primaryColor.withValues(alpha: 0.2);
    }
    return primaryColor.withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    Widget leadingIcon = Icon(
      _getIconForLocation(),
      color: location.isSaved ? primaryColor : Colors.grey,
      size: 24,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getBackgroundColor(),
          child: leadingIcon,
        ),
        title: Text(
          location.name ?? location.address,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          location.subAddress.isEmpty ? location.address : location.subAddress,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.chevron_right,
          color: isDarkMode ? Colors.white54 : Colors.black45,
        ),
      ),
    );
  }

  IconData _getIconForLocation() {
    if (location.icon != null) {
      return _getIconData(location.icon as String);
    }
    return _getDefaultIcon();
  }
}