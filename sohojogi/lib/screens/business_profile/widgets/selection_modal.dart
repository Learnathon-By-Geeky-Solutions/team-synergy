import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class SelectionModal<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T, bool) itemBuilder;
  final Function(String) onToggleItem;

  const SelectionModal({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onToggleItem,
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
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Item list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return itemBuilder(context, item, isDarkMode);
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
}