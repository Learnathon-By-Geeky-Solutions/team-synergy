import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';

void main() {
  group('OrderModel', () {
    // Test data
    final DateTime testDate = DateTime(2023, 5, 10, 15, 30);
    late OrderModel testOrder;

    setUp(() {
      testOrder = OrderModel(
        id: 'test-id-123',
        title: 'Test Order',
        description: 'This is a test order description',
        status: OrderStatus.pending,
        createdAt: testDate,
        serviceType: 'Cleaning',
        price: 150.0,
        location: 'Test Location',
      );
    });

    test('should initialize with correct properties', () {
      expect(testOrder.id, 'test-id-123');
      expect(testOrder.title, 'Test Order');
      expect(testOrder.description, 'This is a test order description');
      expect(testOrder.status, OrderStatus.pending);
      expect(testOrder.createdAt, testDate);
      expect(testOrder.serviceType, 'Cleaning');
      expect(testOrder.price, 150.0);
      expect(testOrder.location, 'Test Location');
    });

    group('statusText getter', () {
      test('should return correct text for each status', () {
        final expectedTexts = {
          OrderStatus.pending: 'Pending',
          OrderStatus.confirmed: 'Confirmed',
          OrderStatus.assigned: 'Assigned',
          OrderStatus.accepted: 'Accepted',
          OrderStatus.completed: 'Completed',
          OrderStatus.cancelled: 'Cancelled',
          OrderStatus.toReview: 'Review',
        };

        expectedTexts.forEach((status, expectedText) {
          final order = OrderModel(
            id: 'test-id',
            title: 'Test',
            description: 'Test',
            status: status,
            createdAt: testDate,
            serviceType: 'Test',
            price: 100.0,
            location: 'Test',
          );
          expect(order.statusText, expectedText);
        });
      });
    });

    group('getStatusColor method', () {
      test('should return correct color for each status in light mode', () {
        const isDarkMode = false;
        final expectedColors = {
          OrderStatus.pending: Colors.orange,
          OrderStatus.confirmed: Colors.green,
          OrderStatus.assigned: Colors.blue,
          OrderStatus.accepted: Colors.pink,
          OrderStatus.completed: Colors.green,
          OrderStatus.cancelled: Colors.red,
          OrderStatus.toReview: primaryColor,
        };

        expectedColors.forEach((status, expectedColor) {
          final order = OrderModel(
            id: 'test-id',
            title: 'Test',
            description: 'Test',
            status: status,
            createdAt: testDate,
            serviceType: 'Test',
            price: 100.0,
            location: 'Test',
          );
          expect(order.getStatusColor(isDarkMode), expectedColor);
        });
      });

      test('should return correct color for each status in dark mode', () {
        const isDarkMode = true;
        // Color handling is the same for both modes in current implementation
        final expectedColors = {
          OrderStatus.pending: Colors.orange,
          OrderStatus.confirmed: Colors.green,
          OrderStatus.assigned: Colors.blue,
          OrderStatus.accepted: Colors.pink,
          OrderStatus.completed: Colors.green,
          OrderStatus.cancelled: Colors.red,
          OrderStatus.toReview: primaryColor,
        };

        expectedColors.forEach((status, expectedColor) {
          final order = OrderModel(
            id: 'test-id',
            title: 'Test',
            description: 'Test',
            status: status,
            createdAt: testDate,
            serviceType: 'Test',
            price: 100.0,
            location: 'Test',
          );
          expect(order.getStatusColor(isDarkMode), expectedColor);
        });
      });
    });
  });
}