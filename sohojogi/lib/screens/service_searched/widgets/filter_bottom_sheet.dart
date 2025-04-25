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

  // Available sort options
  final List<String> _sortOptions = ['Rating', 'Distance', 'Price: Low to High', 'Price: High to Low'];

  @override
  void initState() {
    super.initState();
    // Initialize filter values from initialFilters or defaults
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // Minimum Rating
          const SizedBox(height: 16),
          Text(
            'Minimum Rating',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
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
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  _minRating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          // Categories
          const SizedBox(height: 24),
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.availableCategories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
                selectedColor: primaryColor.withOpacity(0.2),
                checkmarkColor: primaryColor,
                backgroundColor: isDarkMode ? darkColor : Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? primaryColor : (isDarkMode ? lightColor : darkColor),
                ),
              );
            }).toList(),
          ),

          // Sort By
          const SizedBox(height: 24),
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sortOptions.map((option) {
              final isSelected = _sortBy == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sortBy = option;
                    });
                  }
                },
                selectedColor: primaryColor.withOpacity(0.2),
                backgroundColor: isDarkMode ? darkColor : Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? primaryColor : (isDarkMode ? lightColor : darkColor),
                ),
              );
            }).toList(),
          ),

          // Maximum Distance
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum Distance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${_maxDistance.toStringAsFixed(1)} km',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _maxDistance,
            min: 1,
            max: 50,
            divisions: 49,
            activeColor: primaryColor,
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),

          const SizedBox(height: 32),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}