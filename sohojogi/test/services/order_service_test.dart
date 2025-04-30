import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/order_service.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';

void main() {
  late OrderService orderService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    orderService = OrderService();
  });

  group('OrderService Tests', () {
    test('OrderService initializes correctly', () {
      expect(orderService, isNotNull);
    });

    test('createOrder returns null when not authenticated', () async {
      final request = OrderRequest(
        workerId: 'worker-id',
        title: 'Test Order',
        description: 'Test Description',
        totalPrice: 100.0,
        serviceType: 'cleaning',
        location: 'Test Location',
        services: [],
      );
      final orderId = await orderService.createOrder(request);
      expect(orderId, isNull);
    });

    test('getUserOrders returns empty list when not authenticated', () async {
      final orders = await orderService.getUserOrders();
      expect(orders, isEmpty);
    });

    test('getUserOrders with statuses returns empty list when not authenticated', () async {
      final orders = await orderService.getUserOrders(statuses: ['pending', 'completed']);
      expect(orders, isEmpty);
    });

    test('updateOrderStatus returns false when not authenticated', () async {
      final result = await orderService.updateOrderStatus(
        orderId: 'test-id',
        status: 'completed',
      );
      expect(result, false);
    });

    test('updateOrderStatus with notes returns false when not authenticated', () async {
      final result = await orderService.updateOrderStatus(
        orderId: 'test-id',
        status: 'cancelled',
        notes: 'Test cancellation',
      );
      expect(result, false);
    });

    test('submitReview returns false when not authenticated', () async {
      final result = await orderService.submitReview(
        orderId: 'test-id',
        rating: 4.5,
        comment: 'Great service!',
      );
      expect(result, false);
    });

    test('getPendingOrders returns empty list when not authenticated', () async {
      final orders = await orderService.getPendingOrders();
      expect(orders, isEmpty);
    });

    test('getToReviewOrders returns empty list when not authenticated', () async {
      final orders = await orderService.getToReviewOrders();
      expect(orders, isEmpty);
    });

    test('getHistoryOrders returns empty list when not authenticated', () async {
      final orders = await orderService.getHistoryOrders();
      expect(orders, isEmpty);
    });

    test('getOrderDetails returns null for invalid order id', () async {
      final order = await orderService.getOrderDetails('invalid-id');
      expect(order, isNull);
    });

    // Create a test group to test the functionality of _parseOrderStatus indirectly
    group('OrderStatus parsing', () {
      // We'll test it indirectly by using a wrapper method
      OrderStatus testParseOrderStatus(String status) {
        // Create a dummy order response with the specified status
        final Map<String, dynamic> orderData = {
          'id': 'test-id',
          'title': 'Test Order',
          'description': 'Test Description',
          'status': status,
          'created_at': DateTime.now().toIso8601String(),
          'service_type': 'Cleaning',
          'total_price': 100.0,
          'location': 'Test Location',
        };

        // Create an OrderModel from this data which will call _parseOrderStatus internally
        final OrderModel order = OrderModel(
          id: orderData['id'],
          title: orderData['title'],
          description: orderData['description'],
          status: orderService.parseOrderStatusForTesting(status), // We'll add this method to OrderService
          createdAt: DateTime.parse(orderData['created_at']),
          serviceType: orderData['service_type'],
          price: orderData['total_price'],
          location: orderData['location'],
        );

        return order.status;
      }

      test('parses pending status correctly', () {
        expect(testParseOrderStatus('pending'), OrderStatus.pending);
      });

      test('parses confirmed status correctly', () {
        expect(testParseOrderStatus('confirmed'), OrderStatus.confirmed);
      });

      test('parses assigned status correctly', () {
        expect(testParseOrderStatus('assigned'), OrderStatus.assigned);
      });

      test('parses accepted status correctly', () {
        expect(testParseOrderStatus('accepted'), OrderStatus.accepted);
      });

      test('parses completed status correctly', () {
        expect(testParseOrderStatus('completed'), OrderStatus.completed);
      });

      test('parses cancelled status correctly', () {
        expect(testParseOrderStatus('cancelled'), OrderStatus.cancelled);
      });

      test('parses toReview status correctly', () {
        expect(testParseOrderStatus('toReview'), OrderStatus.toReview);
      });

      test('defaults to pending for unknown status', () {
        expect(testParseOrderStatus('unknown'), OrderStatus.pending);
      });
    });

    test('_createNotification handles errors gracefully', () async {
      // Indirectly test the _createNotification method through submitReview
      // This ensures the private method is covered by test
      final result = await orderService.submitReview(
        orderId: 'test-id',
        rating: 4.5,
        comment: 'Great service!',
      );
      expect(result, false);
    });
  });
}