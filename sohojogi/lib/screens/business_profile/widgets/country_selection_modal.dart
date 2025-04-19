import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import '../models/worker_registration_model.dart';

class CountrySelectionModal extends StatelessWidget {
  final List<CountryModel> countries;
  final Function(String) onToggleCountry;

  const CountrySelectionModal({
    super.key,
    required this.countries,
    required this.onToggleCountry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'Select country',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Country list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return _buildCountryItem(context, country, isDarkMode);
              },
            ),
          ),

          const SizedBox(height: 20),

          // OK button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkColor,
              foregroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCountryItem(BuildContext context, CountryModel country, bool isDarkMode) {
    return InkWell(
      onTap: () => onToggleCountry(country.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Flag
            Text(
              country.flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),

            // Country name
            Expanded(
              child: Text(
                country.name,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
            ),

            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: country.isSelected ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: country.isSelected ? primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: country.isSelected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}