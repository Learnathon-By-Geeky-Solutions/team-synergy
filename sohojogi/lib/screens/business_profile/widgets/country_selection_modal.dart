import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import '../models/worker_registration_model.dart';
import 'selection_modal.dart';

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
    return SelectionModal<CountryModel>(
      title: 'Select country',
      items: countries,
      onToggleItem: onToggleCountry,
      itemBuilder: (context, country, isDarkMode) {
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
      },
    );
  }
}