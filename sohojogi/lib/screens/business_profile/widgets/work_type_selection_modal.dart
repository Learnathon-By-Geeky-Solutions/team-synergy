import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import '../models/worker_registration_model.dart';
import 'selection_modal.dart';

class WorkTypeSelectionModal extends StatelessWidget {
  final List<WorkTypeModel> workTypes;
  final Function(String) onToggleWorkType;

  const WorkTypeSelectionModal({
    super.key,
    required this.workTypes,
    required this.onToggleWorkType,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionModal<WorkTypeModel>(
      title: 'Select work type',
      items: workTypes,
      onToggleItem: onToggleWorkType,
      itemBuilder: (context, workType, isDarkMode) {
        return InkWell(
          onTap: () => onToggleWorkType(workType.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Icon placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
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
      },
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