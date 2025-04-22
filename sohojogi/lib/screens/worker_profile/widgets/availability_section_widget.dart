import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';

class AvailabilitySectionWidget extends StatelessWidget {
  final List<WorkerAvailabilityDay> availability;

  const AvailabilitySectionWidget({
    super.key,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: isDarkMode ? darkColor : lightColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 20,
                color: isDarkMode ? lightColor : darkColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Availability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekly schedule
          Column(
            children: _buildAvailabilityRows(isDarkMode),
          ),

          const SizedBox(height: 8),

          // Schedule note
          Text(
            'Note: Availability may change based on current bookings',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvailabilityRows(bool isDarkMode) {
    final Map<DayOfWeek, String> dayNames = {
      DayOfWeek.monday: 'Monday',
      DayOfWeek.tuesday: 'Tuesday',
      DayOfWeek.wednesday: 'Wednesday',
      DayOfWeek.thursday: 'Thursday',
      DayOfWeek.friday: 'Friday',
      DayOfWeek.saturday: 'Saturday',
      DayOfWeek.sunday: 'Sunday',
    };

    // Sort days to ensure they're in proper order
    final sortedAvailability = [...availability];
    sortedAvailability.sort((a, b) => a.day.index.compareTo(b.day.index));

    return sortedAvailability.map((day) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? (day.available ? grayColor.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.05))
              : (day.available ? Colors.green.withValues(alpha: 0.05) : Colors.red.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: day.available
                ? (isDarkMode ? Colors.green.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.2))
                : (isDarkMode ? Colors.red.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.2)),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Day name
            SizedBox(
              width: 100,
              child: Text(
                dayNames[day.day] ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? (day.available ? lightColor : Colors.red.shade300)
                      : (day.available ? darkColor : Colors.red.shade700),
                ),
              ),
            ),

            // Status icon
            Icon(
              day.available ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 16,
              color: day.available
                  ? Colors.green
                  : Colors.red.shade400,
            ),

            const SizedBox(width: 8),

            // Time slots or closed text
            Expanded(
              child: day.available
                  ? _buildTimeSlots(day.timeSlots, isDarkMode)
                  : Text(
                'Closed',
                style: TextStyle(
                  color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTimeSlots(List<TimeSlot> timeSlots, bool isDarkMode) {
    if (timeSlots.isEmpty) {
      return Text(
        'Available (contact for hours)',
        style: TextStyle(
          color: isDarkMode ? lightGrayColor : grayColor,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: timeSlots.map((slot) {
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${slot.start} - ${slot.end}',
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}