import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/notification_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late NotificationService notificationService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    notificationService = NotificationService();
  });

  group('NotificationService Tests', () {
    test('NotificationService initializes correctly', () {
      expect(notificationService, isNotNull);
    });

    test('getNotifications returns empty list when not authenticated', () async {
      final notifications = await notificationService.getNotifications();
      expect(notifications, isA<List>());
      expect(notifications, isEmpty);
    });

    test('markAsRead returns false for invalid notification id', () async {
      final result = await notificationService.markAsRead('invalid-id');
      expect(result, isFalse);
    });

    test('markAllAsRead returns false when not authenticated', () async {
      final result = await notificationService.markAllAsRead();
      expect(result, isFalse);
    });
  });
}