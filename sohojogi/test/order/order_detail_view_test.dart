import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';
import 'package:sohojogi/screens/order/view_model/order_view_model.dart';
import 'package:sohojogi/screens/order/views/order_detail_view.dart';

class MockOrderViewModel extends Mock implements OrderViewModel {
  @override
  bool isLoading = false;
}

void main() {
  group('OrderDetailView', () {
    // Test data
    final DateTime testDate = DateTime(2023, 5, 10, 15, 30);
    late OrderModel pendingOrder;
    late OrderModel completedOrder;
    late OrderModel toReviewOrder;
    late MockOrderViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockOrderViewModel();

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

    Widget buildTestWidget(OrderModel order) {
      return MaterialApp(
        home: ChangeNotifierProvider<OrderViewModel>.value(
          value: mockViewModel,
          child: OrderDetailView(order: order),
        ),
      );
    }

    testWidgets('renders order details correctly for pending order', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(pendingOrder));

      // Verify basic details are displayed
      expect(find.text('Pending Order'), findsOneWidget);
      expect(find.text('Test pending order description'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Service'), findsOneWidget);
      expect(find.text('Cleaning'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('৳150'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Dhaka'), findsOneWidget);

      // Verify cancel button is displayed for pending order
      expect(find.text('Cancel Order'), findsOneWidget);
    });

    testWidgets('renders order details correctly for completed order', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(completedOrder));

      // Verify basic details are displayed
      expect(find.text('Completed Order'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);

      // Verify View Receipt button is displayed for completed order
      expect(find.text('View Receipt'), findsOneWidget);
    });

    testWidgets('renders review form for toReview order', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(toReviewOrder));

      // Verify review form elements are displayed
      expect(find.text('Leave a review'), findsOneWidget);
      // Check for the rating stars instead of "Rating:" text
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Submit Review'), findsOneWidget);
    });

    testWidgets('can tap stars to change rating', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(toReviewOrder));

      // Initially all 5 stars should be filled
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byIcon(Icons.star_border), findsNothing);

      // Tap the third star
      await tester.tap(find.byIcon(Icons.star).at(2));
      await tester.pump();

      // Now we should have 3 filled stars and 2 empty stars
      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('shows cancel order dialog when cancel button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(pendingOrder));

      // Tap cancel button
      await tester.tap(find.text('Cancel Order'));
      await tester.pumpAndSettle();

      // Check for dialog presence using more specific finders
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Please provide a reason for cancellation:'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('shows snackbar when review text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(toReviewOrder));

      // Tap submit button without entering review text
      await tester.tap(find.text('Submit Review'));
      await tester.pump();

      // Verify snackbar is shown
      expect(find.text('Please enter a review'), findsOneWidget);
    });

    testWidgets('cancel order dialog requires reason', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(pendingOrder));

      // Tap cancel button
      await tester.tap(find.text('Cancel Order'));
      await tester.pumpAndSettle();

      // Find the "Cancel Order" button in the dialog using its position
      final cancelButton = find.text('Cancel Order').last;
      await tester.tap(cancelButton);
      await tester.pump();

      // Verify snackbar is shown
      expect(find.text('Please provide a reason'), findsOneWidget);
    });
  });
}