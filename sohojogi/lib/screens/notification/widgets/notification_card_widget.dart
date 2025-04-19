import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import '../../utils/date_time_utils.dart';


class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: notification.isRead
          ? (isDarkMode ? darkColor : lightColor)
          : (isDarkMode ? darkColor.withOpacity(0.8) : primaryColor.withOpacity(0.05)),
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
                  color: _getIconBackgroundColor(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getIconData(notification.type),
                    color: _getIconBackgroundColor(notification.type),
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
                      _formatTimeAgo(notification.timestamp),
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

  // format time ago

  String _formatTimeAgo(DateTime dateTime) {
    // Don't cast the Duration to DateTime - just pass the original dateTime
    return formatTimeAgo(dateTime);
  }

  IconData _getIconData(NotificationType type) {
    switch (type) {
      case NotificationType.orderAccepted:
        return Icons.assignment;
      case NotificationType.confirmOrder:
        return Icons.verified_user;
      case NotificationType.orderAssigned:
        return Icons.engineering;
      case NotificationType.orderCompleted:
        return Icons.check_circle;
      case NotificationType.orderCancelled:
        return Icons.sentiment_dissatisfied;
      case NotificationType.announcement:
        return Icons.campaign;
    }
  }

  Color _getIconBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.orderAccepted:
        return Colors.orange;
      case NotificationType.confirmOrder:
        return Colors.purple;
      case NotificationType.orderAssigned:
        return Colors.blue;
      case NotificationType.orderCompleted:
        return Colors.green;
      case NotificationType.orderCancelled:
        return Colors.red;
      case NotificationType.announcement:
        return Colors.grey.shade700;
    }
  }
}