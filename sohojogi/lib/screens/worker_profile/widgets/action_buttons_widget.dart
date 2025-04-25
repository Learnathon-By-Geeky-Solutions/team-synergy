import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class ActionButtonsWidget extends StatelessWidget {
  final WorkerProfileModel worker;
  final VoidCallback onHirePressed;
  final bool hirePending;
  final List<WorkerServiceModel> selectedServices;

  const ActionButtonsWidget({
    super.key,
    required this.worker,
    required this.onHirePressed,
    required this.hirePending,
    required this.selectedServices,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bool canHire = selectedServices.isNotEmpty;

    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Hire button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canHire ? (hirePending ? null : onHirePressed) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: canHire
                    ? primaryColor.withOpacity(0.6)
                    : isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              child: hirePending
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                canHire ? 'Hire Now' : 'Select Services First',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: canHire ? Colors.white : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Call button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle call action
              },
              icon: const Icon(Icons.phone, size: 16),
              label: const Text('Call'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: isDarkMode ? lightGrayColor : grayColor),
                foregroundColor: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Message button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle message action
              },
              icon: const Icon(Icons.message, size: 16),
              label: const Text('Chat'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: isDarkMode ? lightGrayColor : grayColor),
                foregroundColor: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}