import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';
import 'package:sohojogi/screens/order/widgets/order_card_widget.dart';

void main() {
  group('OrderCardWidget', () {
    // Test data
    final DateTime testDate = DateTime.now().subtract(const Duration(hours: 3));
    late OrderModel pendingOrder;
    late OrderModel completedOrder;
    late OrderModel toReviewOrder;

    setUp(() {
      pendingOrder = OrderModel(
        id: 'test-id-1',
        title: 'Pending Order',
        description: 'Test pending order description',
        status: OrderStatus.pending,
        createdAt: testDate,
        serviceType: 'Cleaning',
        price: 150.0,
        location: 'Dhaka',
      );

      completedOrder = OrderModel(
        id: 'test-id-2',
        title: 'Completed Order',
        description: 'Test completed order description',
        status: OrderStatus.completed,
        createdAt: testDate,
        serviceType: 'Repair',
        price: 250.0,
        location: 'Chittagong',
      );

      toReviewOrder = OrderModel(
        id: 'test-id-3',
        title: 'To Review Order',
        description: 'Test to review order description',
        status: OrderStatus.toReview,
        createdAt: testDate,
        serviceType: 'Plumbing',
        price: 350.0,
        location: 'Sylhet',
      );
    });

    testWidgets('shows correct status badge for pending order', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: OrderCardWidget(
              order: pendingOrder,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows correct status badge for completed order', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: OrderCardWidget(
              order: completedOrder,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('displays Leave Review button for toReview order status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: OrderCardWidget(
              order: toReviewOrder,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Leave Review'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays Leave Review button when onMarkForReviewPressed provided and order is completed',
            (WidgetTester tester) async {
          bool reviewPressed = false;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData.light(),
              home: Scaffold(
                body: OrderCardWidget(
                  order: completedOrder,
                  onTap: () {},
                  onMarkForReviewPressed: () { reviewPressed = true; },
                ),
              ),
            ),
          );

          expect(find.text('Leave Review'), findsOneWidget);

          await tester.tap(find.text('Leave Review'));
          expect(reviewPressed, true);
        });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: OrderCardWidget(
              order: pendingOrder,
              onTap: () {},
            ),
          ),
        ),
      );

      // Just verifying that the widget renders without errors in dark mode
      expect(find.text('Pending Order'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('long text properly handles overflow', (WidgetTester tester) async {
      final longTextOrder = OrderModel(
        id: 'test-id-4',
        title: 'Very Long Title That Should Definitely Overflow ' * 3,
        description: 'This is an extremely long description that will certainly overflow ' * 5,
        status: OrderStatus.pending,
        createdAt: testDate,
        serviceType: 'Cleaning',
        price: 150.0,
        location: 'This is a very long location name that should overflow ' * 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: OrderCardWidget(
                order: longTextOrder,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Just verifying the widget renders without errors with long text
      expect(find.byType(OrderCardWidget), findsOneWidget);
    });
  });
}