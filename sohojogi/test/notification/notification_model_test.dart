import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';

void main() {
  group('NotificationModel', () {
    test('should create a notification model with required parameters', () {
      final notification = NotificationModel(
        id: '1',
        type: NotificationType.orderAccepted,
        title: 'Order Accepted',
        message: 'Your order has been accepted',
        timestamp: DateTime(2023, 5, 15, 10, 30),
      );

      expect(notification.id, '1');
      expect(notification.type, NotificationType.orderAccepted);
      expect(notification.title, 'Order Accepted');
      expect(notification.message, 'Your order has been accepted');
      expect(notification.timestamp, DateTime(2023, 5, 15, 10, 30));
      expect(notification.actionUrl, null);
      expect(notification.isRead, false);
    });

    test('should create a notification model with all parameters', () {
      final notification = NotificationModel(
        id: '2',
        type: NotificationType.announcement,
        title: 'New Feature',
        message: 'We added a new feature',
        timestamp: DateTime(2023, 5, 16, 15, 45),
        actionUrl: 'app://features',
        isRead: true,
      );

      expect(notification.id, '2');
      expect(notification.type, NotificationType.announcement);
      expect(notification.title, 'New Feature');
      expect(notification.message, 'We added a new feature');
      expect(notification.timestamp, DateTime(2023, 5, 16, 15, 45));
      expect(notification.actionUrl, 'app://features');
      expect(notification.isRead, true);
    });

    test('should check equality of enum values', () {
      expect(NotificationType.orderAccepted, NotificationType.orderAccepted);
      expect(NotificationType.orderAccepted != NotificationType.announcement, true);
    });
  });
}