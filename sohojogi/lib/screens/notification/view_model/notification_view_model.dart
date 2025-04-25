import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../base/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<NotificationModel> notifications = [];

  Future<void> loadNotifications() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Load notifications from backend
      notifications = await _notificationService.getNotifications();
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to load notifications: ${e.toString()}';
      debugPrint('Error loading notifications: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(NotificationModel notification) async {
    try {
      final success = await _notificationService.markAsRead(notification.id);

      if (success) {
        final index = notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          notifications[index] = NotificationModel(
            id: notification.id,
            type: notification.type,
            title: notification.title,
            message: notification.message,
            timestamp: notification.timestamp,
            actionUrl: notification.actionUrl,
            isRead: true,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }
}