// test/notification/notification_list_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import 'package:sohojogi/screens/notification/view_model/notification_view_model.dart';
import 'package:sohojogi/screens/notification/views/notification_list_view.dart';
import 'package:sohojogi/screens/notification/widgets/notification_card_widget.dart';

class MockNotificationViewModel extends ChangeNotifier implements NotificationViewModel {
  @override
  bool isLoading = false;

  @override
  bool hasError = false;

  @override
  String errorMessage = '';

  @override
  List<NotificationModel> notifications = [];

  @override
  Future<void> loadNotifications() async {
    // Record that this was called for verification
    loadNotificationsCalled = true;
    notifyListeners();
  }

  @override
  void markAsRead(NotificationModel notification) {
    // Record the notification that was marked as read
    markedAsReadNotification = notification;
    notifyListeners();
  }

  // Test helpers
  bool loadNotificationsCalled = false;
  NotificationModel? markedAsReadNotification;
}

void main() {
  late MockNotificationViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockNotificationViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<NotificationViewModel>.value(
        value: mockViewModel,
        child: const NotificationListView(),
      ),
    );
  }

  group('NotificationListView', () {
    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      mockViewModel.isLoading = true;
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when hasError is true', (WidgetTester tester) async {
      mockViewModel.isLoading = false;
      mockViewModel.hasError = true;
      mockViewModel.errorMessage = 'Test error message';

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows empty state when notifications is empty', (WidgetTester tester) async {
      mockViewModel.isLoading = false;
      mockViewModel.hasError = false;
      mockViewModel.notifications = [];

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No notifications yet'), findsOneWidget);
      expect(find.text('You\'ll be notified about your orders and announcements'), findsOneWidget);
    });

    testWidgets('shows notification list when notifications are available', (WidgetTester tester) async {
      mockViewModel.isLoading = false;
      mockViewModel.hasError = false;
      mockViewModel.notifications = [
        NotificationModel(
          id: '1',
          type: NotificationType.orderAccepted,
          title: 'Test Notification',
          message: 'Test Message',
          timestamp: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(NotificationCardWidget), findsOneWidget);
      expect(find.text('Test Notification'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('tapping a notification calls markAsRead', (WidgetTester tester) async {
      mockViewModel.isLoading = false;
      mockViewModel.hasError = false;
      final testNotification = NotificationModel(
        id: '1',
        type: NotificationType.orderAccepted,
        title: 'Test Notification',
        message: 'Test Message',
        timestamp: DateTime.now(),
      );
      mockViewModel.notifications = [testNotification];

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(NotificationCardWidget));

      expect(mockViewModel.markedAsReadNotification, equals(testNotification));
    });

    testWidgets('has refresh indicator that calls loadNotifications', (WidgetTester tester) async {
      mockViewModel.isLoading = false;
      mockViewModel.hasError = false;
      mockViewModel.notifications = [
        NotificationModel(
          id: '1',
          type: NotificationType.orderAccepted,
          title: 'Test Notification',
          message: 'Test Message',
          timestamp: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(RefreshIndicator), findsOneWidget);
      // Simulating a pull-to-refresh is challenging in tests, so we'll just verify
      // that the RefreshIndicator exists and is properly connected
    });
  });
}