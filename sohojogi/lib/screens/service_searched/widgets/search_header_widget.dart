// lib/screens/service_searched/widgets/search_header_widget.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class SearchHeaderWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onFilterTap;
  final VoidCallback onBackTap;

  const SearchHeaderWidget({
    super.key,
    required this.searchQuery,
    required this.onFilterTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Logo and location row
          Row(
            children: [
              // Logo
              Row(
                children: [
                  Text(
                    'Sohojogi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Location display
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(
                    'Mirpur 14, Dhaka',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search bar with back button
          Row(
            children: [
              // Back button
              InkWell(
                onTap: onBackTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? grayColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? lightColor : darkColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Search field
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode ? grayColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: isDarkMode ? lightGrayColor : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        searchQuery,
                        style: TextStyle(
                          color: isDarkMode ? lightColor : darkColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Filter button
              InkWell(
                onTap: onFilterTap,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_list,
                        color: lightColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: lightColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}