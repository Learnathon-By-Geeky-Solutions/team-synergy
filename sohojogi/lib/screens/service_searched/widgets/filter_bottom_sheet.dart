import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;
  final List<String> availableCategories;

  const FilterBottomSheetWidget({
    super.key,
    this.initialFilters,
    required this.onApplyFilters,
    required this.availableCategories,
  });

  @override
  State<FilterBottomSheetWidget> createState() => _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late double _minRating;
  late Set<String> _selectedCategories;
  late String _sortBy;
  late double _maxDistance;

  final List<String> _sortOptions = ['Rating', 'Distance', 'Price: Low to High', 'Price: High to Low'];

  @override
  void initState() {
    super.initState();
    _minRating = widget.initialFilters?['minRating'] ?? 0.0;
    _selectedCategories = Set<String>.from(widget.initialFilters?['categories'] ?? []);
    _sortBy = widget.initialFilters?['sortBy'] ?? 'Rating';
    _maxDistance = widget.initialFilters?['maxDistance'] ?? 10.0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // Minimum Rating
          const SizedBox(height: 16),
          Text('Minimum Rating', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            label: _minRating.toString(),
            activeColor: primaryColor,
            onChanged: (value) {
              setState(() {
                _minRating = value;
              });
            },
          ),

          // Categories
          const SizedBox(height: 16),
          Text('Categories', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.availableCategories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCategories.remove(category);
                    } else {
                      _selectedCategories.add(category);
                    }
                  });
                },
                child: Chip(
                  label: Text(category),
                  backgroundColor: isSelected ? primaryColor : Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? lightColor : darkColor,
                  ),
                ),
              );
            }).toList(),
          ),

          // Sort By
          const SizedBox(height: 16),
          Text('Sort By', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children: _sortOptions.map((option) {
              final isSelected = _sortBy == option;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _sortBy = option;
                  });
                },
                child: Chip(
                  label: Text(option),
                  backgroundColor: isSelected ? primaryColor : Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? lightColor : darkColor,
                  ),
                ),
              );
            }).toList(),
          ),

          // Maximum Distance
          const SizedBox(height: 16),
          Text('Maximum Distance', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _maxDistance,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_maxDistance.toStringAsFixed(1)} km',
            activeColor: primaryColor,
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),

          // Apply Filters Button
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              final filters = {
                'minRating': _minRating,
                'categories': _selectedCategories.toList(),
                'sortBy': _sortBy,
                'maxDistance': _maxDistance,
              };
              widget.onApplyFilters(filters);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: lightColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Apply Filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}