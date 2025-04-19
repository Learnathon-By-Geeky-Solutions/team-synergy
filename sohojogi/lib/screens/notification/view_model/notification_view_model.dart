import 'package:flutter/material.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<NotificationModel> notifications = [];

  Future<void> loadNotifications() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      notifications = _getMockNotifications();
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to load notifications. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(NotificationModel notification) {
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

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.orderAccepted,
        title: 'Order Accepted',
        message: 'Your order for plumbing service has been accepted by the service provider.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionUrl: '/order/123',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.confirmOrder,
        title: 'Confirm Your Order',
        message: 'Please confirm your order for electrical repair service within 24 hours.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        actionUrl: '/order/124',
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.orderAssigned,
        title: 'Service Provider Assigned',
        message: 'John Doe has been assigned to your cleaning order. They will arrive at the scheduled time.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        actionUrl: '/order/125',
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.orderCompleted,
        title: 'Order Completed',
        message: 'Your AC repair service has been completed. Please leave a review for the service provider.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        actionUrl: '/order/126',
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.orderCancelled,
        title: 'Order Cancelled',
        message: 'Your painting service order has been cancelled as requested.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        actionUrl: '/order/127',
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.announcement,
        title: 'Holiday Notice',
        message: 'Our services will be limited during the upcoming holiday weekend. Please plan accordingly.',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        isRead: true,
      ),
      // Add other mock notifications here...
    ];
  }
}