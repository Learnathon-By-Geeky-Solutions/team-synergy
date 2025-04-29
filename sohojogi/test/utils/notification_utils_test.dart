import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import 'package:sohojogi/utils/notification_utils.dart';

void main() {
  group('NotificationUtils - getIconData', () {
    test('returns correct icon for orderAccepted', () {
      expect(
          NotificationUtils.getIconData(NotificationType.orderAccepted),
          Icons.assignment
      );
    });

    test('returns correct icon for confirmOrder', () {
      expect(
          NotificationUtils.getIconData(NotificationType.confirmOrder),
          Icons.verified_user
      );
    });

    test('returns correct icon for orderAssigned', () {
      expect(
          NotificationUtils.getIconData(NotificationType.orderAssigned),
          Icons.engineering
      );
    });

    test('returns correct icon for orderCompleted', () {
      expect(
          NotificationUtils.getIconData(NotificationType.orderCompleted),
          Icons.check_circle
      );
    });

    test('returns correct icon for orderCancelled', () {
      expect(
          NotificationUtils.getIconData(NotificationType.orderCancelled),
          Icons.sentiment_dissatisfied
      );
    });

    test('returns correct icon for announcement', () {
      expect(
          NotificationUtils.getIconData(NotificationType.announcement),
          Icons.campaign
      );
    });
  });

  group('NotificationUtils - getIconBackgroundColor', () {
    test('returns correct color for orderAccepted', () {
      expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderAccepted),
          Colors.orange
      );
    });

    test('returns correct color for confirmOrder', () {
      expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.confirmOrder),
          Colors.purple
      );
    });

    test('returns correct color for orderAssigned', () {
      expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderAssigned),
          Colors.blue
      );
    });

    test('returns correct color for orderCompleted', () {
      expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderCompleted),
          Colors.green
      );
    });

    test('returns correct color for orderCancelled', () {
      expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderCancelled),
          Colors.red
      );
    });

    test('returns correct color for announcement', () {
      final color = NotificationUtils.getIconBackgroundColor(NotificationType.announcement);
      expect(color, Colors.grey.shade700);
    });
  });

  group('NotificationUtils - formatTimeAgo', () {
    test('formats time in days', () {
      final now = DateTime.now();
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      expect(NotificationUtils.formatTimeAgo(twoDaysAgo), '2 days ago');

      final oneDayAgo = now.subtract(const Duration(days: 1));
      expect(NotificationUtils.formatTimeAgo(oneDayAgo), '1 day ago');
    });

    test('formats time in hours', () {
      final now = DateTime.now();
      final twoHoursAgo = now.subtract(const Duration(hours: 2));
      expect(NotificationUtils.formatTimeAgo(twoHoursAgo), '2 hrs ago');

      final oneHourAgo = now.subtract(const Duration(hours: 1));
      expect(NotificationUtils.formatTimeAgo(oneHourAgo), '1 hr ago');
    });

    test('formats time in minutes', () {
      final now = DateTime.now();
      final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
      expect(NotificationUtils.formatTimeAgo(fiveMinutesAgo), '5 min ago');
    });

    test('formats recent time as just now', () {
      final now = DateTime.now();
      final justNow = now.subtract(const Duration(seconds: 30));
      expect(NotificationUtils.formatTimeAgo(justNow), 'Just now');
    });
  });
}