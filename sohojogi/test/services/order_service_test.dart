import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/order_service.dart';
import 'package:sohojogi/constants/keys.dart';

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

    test('getOrderDetails returns null for invalid order id', () async {
      final order = await orderService.getOrderDetails('invalid-id');
      expect(order, isNull);
    });
  });
}