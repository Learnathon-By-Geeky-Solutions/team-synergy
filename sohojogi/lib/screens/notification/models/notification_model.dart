// lib/screens/notification/models/notification_model.dart
enum NotificationType {
  orderAccepted,
  confirmOrder,
  orderAssigned,
  orderCompleted,
  orderCancelled,
  announcement,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? actionUrl;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.actionUrl,
    this.isRead = false,
  });
}