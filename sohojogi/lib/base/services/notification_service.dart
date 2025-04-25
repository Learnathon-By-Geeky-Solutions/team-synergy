import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/notification/models/notification_model.dart';

class NotificationService {
  final _supabase = Supabase.instance.client;

  // Get all notifications for the current user
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      // Fetch notifications from the backend
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Convert to NotificationModel objects
      return response.map<NotificationModel>((notification) {
        return NotificationModel(
          id: notification['id'],
          type: _parseNotificationType(notification['type']),
          title: notification['title'],
          message: notification['message'],
          timestamp: DateTime.parse(notification['created_at']),
          actionUrl: notification['action_url'],
          isRead: notification['is_read'] ?? false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting notifications: $e');
      return [];
    }
  }

  // Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _supabase.from('notifications').update({
        'is_read': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);

      return true;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await _supabase.from('notifications').update({
        'is_read': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId).eq('is_read', false);

      return true;
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      return false;
    }
  }

  // Helper method to parse notification type
  NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'orderAccepted':
        return NotificationType.orderAccepted;
      case 'confirmOrder':
        return NotificationType.confirmOrder;
      case 'orderAssigned':
        return NotificationType.orderAssigned;
      case 'orderCompleted':
        return NotificationType.orderCompleted;
      case 'orderCancelled':
        return NotificationType.orderCancelled;
      case 'newOrder':
      case 'orderStatusUpdate':
      case 'orderToReview':
      case 'newReview':
      default:
        return NotificationType.announcement;
    }
  }
}