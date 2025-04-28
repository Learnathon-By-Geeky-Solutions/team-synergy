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
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bool canHire = selectedServices.isNotEmpty;

    return Container(
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildHireButton(context, isDarkMode, canHire),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              icon: Icons.phone,
              label: 'Call',
              isDarkMode: isDarkMode,
              onPressed: () {
                // Handle call action
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              icon: Icons.message,
              label: 'Chat',
              isDarkMode: isDarkMode,
              onPressed: () {
                // Handle message action
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHireButton(BuildContext context, bool isDarkMode, bool canHire) {
    final backgroundColor = _getHireButtonColor(isDarkMode, canHire);
    final textColor = _getHireButtonTextColor(isDarkMode, canHire);
    final onPressedHandler = _getOnPressedHandler(canHire);

    return ElevatedButton(
      onPressed: onPressedHandler,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        disabledBackgroundColor: backgroundColor,
      ),
      child: _buildHireButtonChild(canHire, textColor),
    );
  }

  VoidCallback? _getOnPressedHandler(bool canHire) {
    if (!canHire) return null;
    if (hirePending) return null;
    return onHirePressed;
  }

  Widget _buildHireButtonChild(bool canHire, Color textColor) {
    if (hirePending) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }

    return Text(
      canHire ? 'Hire Now' : 'Select Services First',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: isDarkMode ? lightGrayColor : grayColor),
        foregroundColor: isDarkMode ? lightColor : darkColor,
      ),
    );
  }

  Color _getHireButtonColor(bool isDarkMode, bool canHire) {
    if (!canHire) {
      return isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    }
    return hirePending ? primaryColor.withValues(alpha: 0.6) : primaryColor;
  }

  Color _getButtonTextColor(bool canHire, bool isDarkMode) {
    if (canHire) {
      return Colors.white;
    }
    return isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
  }

  Color _getHireButtonTextColor(bool isDarkMode, bool canHire) {
    return _getButtonTextColor(canHire, isDarkMode);
  }

}