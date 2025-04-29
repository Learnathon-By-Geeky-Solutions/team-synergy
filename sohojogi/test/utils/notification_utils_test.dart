import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import 'package:sohojogi/utils/notification_utils.dart';

void main() {
  group('NotificationUtils', () {
    group('getIconData', () {
      test('returns correct icon for orderAccepted', () {
        expect(
          NotificationUtils.getIconData(NotificationType.orderAccepted),
          equals(Icons.assignment),
        );
      });

      test('returns correct icon for confirmOrder', () {
        expect(
          NotificationUtils.getIconData(NotificationType.confirmOrder),
          equals(Icons.verified_user),
        );
      });

      test('returns correct icon for orderAssigned', () {
        expect(
          NotificationUtils.getIconData(NotificationType.orderAssigned),
          equals(Icons.engineering),
        );
      });

      test('returns correct icon for orderCompleted', () {
        expect(
          NotificationUtils.getIconData(NotificationType.orderCompleted),
          equals(Icons.check_circle),
        );
      });

      test('returns correct icon for orderCancelled', () {
        expect(
          NotificationUtils.getIconData(NotificationType.orderCancelled),
          equals(Icons.sentiment_dissatisfied),
        );
      });

      test('returns correct icon for announcement', () {
        expect(
          NotificationUtils.getIconData(NotificationType.announcement),
          equals(Icons.campaign),
        );
      });
    });

    group('getIconBackgroundColor', () {
      test('returns correct color for orderAccepted', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderAccepted),
          equals(Colors.orange),
        );
      });

      test('returns correct color for confirmOrder', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.confirmOrder),
          equals(Colors.purple),
        );
      });

      test('returns correct color for orderAssigned', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderAssigned),
          equals(Colors.blue),
        );
      });

      test('returns correct color for orderCompleted', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderCompleted),
          equals(Colors.green),
        );
      });

      test('returns correct color for orderCancelled', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.orderCancelled),
          equals(Colors.red),
        );
      });

      test('returns correct color for announcement', () {
        expect(
          NotificationUtils.getIconBackgroundColor(NotificationType.announcement),
          equals(Colors.grey.shade700),
        );
      });
    });

    group('formatTimeAgo', () {
      test('returns "Just now" for current time', () {
        final now = DateTime.now();
        expect(
          NotificationUtils.formatTimeAgo(now),
          equals('Just now'),
        );
      });

      test('returns correct minutes format', () {
        final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
        expect(
          NotificationUtils.formatTimeAgo(fiveMinutesAgo),
          equals('5 min ago'),
        );
      });

      test('returns correct hours format (singular)', () {
        final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
        expect(
          NotificationUtils.formatTimeAgo(oneHourAgo),
          equals('1 hr ago'),
        );
      });

      test('returns correct hours format (plural)', () {
        final threeHoursAgo = DateTime.now().subtract(const Duration(hours: 3));
        expect(
          NotificationUtils.formatTimeAgo(threeHoursAgo),
          equals('3 hrs ago'),
        );
      });

      test('returns correct days format (singular)', () {
        final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
        expect(
          NotificationUtils.formatTimeAgo(oneDayAgo),
          equals('1 day ago'),
        );
      });

      test('returns correct days format (plural)', () {
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
        expect(
          NotificationUtils.formatTimeAgo(threeDaysAgo),
          equals('3 days ago'),
        );
      });
    });
  });
}