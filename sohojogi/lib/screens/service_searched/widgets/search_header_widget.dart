// lib/screens/service_searched/widgets/search_header_widget.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class SearchHeaderWidget extends StatelessWidget {
  final String searchQuery;
  final String currentLocation;
  final VoidCallback onFilterTap;
  final VoidCallback onBackTap;
  final VoidCallback onLocationTap;

  const SearchHeaderWidget({
    super.key,
    required this.searchQuery,
    required this.currentLocation,
    required this.onFilterTap,
    required this.onBackTap,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top row with back button and filter
          Row(
            children: [
              // Back button
              InkWell(
                onTap: onBackTap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
              ),
              const Spacer(),
              // Filter button
              InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                  ),
                  child: Icon(
                    Icons.filter_list,
                    size: 20,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Location bar
          InkWell(
            onTap: onLocationTap,
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    currentLocation,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search query display
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Showing results for "$searchQuery"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}