// lib/screens/business_profile/widgets/work_type_selection_modal.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import '../models/worker_registration_model.dart';

class WorkTypeSelectionModal extends StatelessWidget {
  final List<WorkTypeModel> workTypes;
  final Function(String) onToggleWorkType;

  const WorkTypeSelectionModal({
    Key? key,
    required this.workTypes,
    required this.onToggleWorkType,
  }) : super(key: key);

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
            'Select work type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Work type list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workTypes.length,
              itemBuilder: (context, index) {
                final workType = workTypes[index];
                return _buildWorkTypeItem(context, workType, isDarkMode);
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

  Widget _buildWorkTypeItem(BuildContext context, WorkTypeModel workType, bool isDarkMode) {
    return InkWell(
      onTap: () => onToggleWorkType(workType.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Icon placeholder (in a real app, you'd use actual icons)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForWorkType(workType.name),
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Work type name
            Expanded(
              child: Text(
                workType.name,
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
                color: workType.isSelected ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: workType.isSelected ? primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: workType.isSelected
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

  IconData _getIconForWorkType(String workType) {
    switch (workType) {
      case 'Plumber':
        return Icons.plumbing;
      case 'Cleaning':
        return Icons.cleaning_services;
      case 'Carpenter':
        return Icons.handyman;
      case 'Electrician':
        return Icons.electrical_services;
      case 'Painter':
        return Icons.format_paint;
      case 'AC Technician':
        return Icons.ac_unit;
      case 'Gardener':
        return Icons.grass;
      case 'Driver':
        return Icons.drive_eta;
      default:
        return Icons.work;
    }
  }
}