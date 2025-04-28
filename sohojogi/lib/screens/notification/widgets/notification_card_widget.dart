import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import '../../../utils/notification_utils.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  Color _getCardBackgroundColor(bool isRead, bool isDarkMode) {
    if (isRead) {
      return isDarkMode ? darkColor : lightColor;
    }

    return isDarkMode
        ? darkColor.withValues(alpha: 0.8)
        : primaryColor.withValues(alpha: 0.05);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color cardColor = _getCardBackgroundColor(notification.isRead, isDarkMode);


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: cardColor, // Use the extracted variable
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: NotificationUtils.getIconBackgroundColor(
                      notification.type).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    NotificationUtils.getIconData(notification.type),
                    color: NotificationUtils.getIconBackgroundColor(
                        notification.type),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? lightColor : darkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      NotificationUtils.formatTimeAgo(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

