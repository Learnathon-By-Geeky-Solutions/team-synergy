import 'package:flutter/material.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';

class NotificationUtils {
  static IconData getIconData(NotificationType type) {
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

  static Color getIconBackgroundColor(NotificationType type) {
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

  static String formatTimeAgo(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hr' : 'hrs'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}