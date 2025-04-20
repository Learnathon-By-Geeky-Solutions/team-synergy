import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.scrollController,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _minRating;
  late List<String> _selectedCategories;
  late String _sortBy;
  late double _maxDistance;

  final List<String> _availableCategories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Cleaner',
    'Painter',
    'Gardener'
  ];

  final List<String> _sortOptions = [
    'Rating',
    'Distance',
    'Price: Low to High',
    'Price: High to Low',
  ];

  @override
  void initState() {
    super.initState();
    _minRating = widget.initialFilters['minRating'] ?? 0.0;
    _selectedCategories = List<String>.from(widget.initialFilters['categories'] ?? []);
    _sortBy = widget.initialFilters['sortBy'] ?? 'Rating';
    _maxDistance = widget.initialFilters['maxDistance'] ?? 10.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
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
          children: _availableCategories.map((category) {
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
              'categories': _selectedCategories,
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
    );
  }
}