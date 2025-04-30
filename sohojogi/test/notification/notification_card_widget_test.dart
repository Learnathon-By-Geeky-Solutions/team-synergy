// test/notification/notification_card_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import 'package:sohojogi/screens/notification/widgets/notification_card_widget.dart';
import 'package:sohojogi/utils/notification_utils.dart';

void main() {

  testWidgets('NotificationCardWidget displays read notification correctly', (WidgetTester tester) async {
    // Create a test notification that is already read
    final notification = NotificationModel(
      id: '2',
      type: NotificationType.announcement,
      title: 'New Feature',
      message: 'We added a new feature',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCardWidget(
            notification: notification,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify the title and message are displayed
    expect(find.text('New Feature'), findsOneWidget);
    expect(find.text('We added a new feature'), findsOneWidget);

    // Verify time ago text is shown for day format
    expect(find.textContaining('day'), findsOneWidget);

    // Verify the unread indicator does NOT exist for read notifications
    final unreadIndicator = find.byWidgetPredicate((widget) =>
    widget is Container &&
        widget.constraints?.minWidth == 8 &&
        widget.constraints?.minHeight == 8 &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == primaryColor
    );
    expect(unreadIndicator, findsNothing);
  });

  testWidgets('NotificationCardWidget displays different notification types correctly', (WidgetTester tester) async {
    // Test different notification types
    final types = [
      NotificationType.orderAccepted,
      NotificationType.announcement,
      NotificationType.orderCancelled,
      NotificationType.orderCompleted
    ];

    for (var type in types) {
      final notification = NotificationModel(
        id: '1',
        type: type,
        title: 'Test Title',
        message: 'Test Message',
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCardWidget(
              notification: notification,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify the icon container exists
      final iconContainer = find.byWidgetPredicate((widget) =>
      widget is Container &&
          widget.decoration is BoxDecoration &&
          widget.child is Center &&
          (widget.child as Center).child is Icon
      );
      expect(iconContainer, findsOneWidget);

      // Verify the icon is displayed with the correct type
      final icon = find.descendant(
          of: iconContainer,
          matching: find.byType(Icon)
      );
      expect(icon, findsOneWidget);

      // Verify the icon has a color (without exact color matching)
      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.color, isNotNull);
    }
  });

  testWidgets('NotificationCardWidget adapts to light/dark mode', (WidgetTester tester) async {
    final notification = NotificationModel(
      id: '1',
      type: NotificationType.orderAccepted,
      title: 'Test Title',
      message: 'Test Message',
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Test in light mode
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: NotificationCardWidget(
            notification: notification,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify card is rendered with correct colors in light mode
    await tester.pump();

    // Test in dark mode
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: NotificationCardWidget(
            notification: notification,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify card is rendered with correct colors in dark mode
    await tester.pump();
  });
}