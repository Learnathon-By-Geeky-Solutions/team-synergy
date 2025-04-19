import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<OrderModel> pendingOrders = [];
  List<OrderModel> reviewOrders = [];
  List<OrderModel> historyOrders = [];

  Future<void> loadOrders() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    pendingOrders = _getMockPendingOrders();
    reviewOrders = _getMockReviewOrders();
    historyOrders = _getMockHistoryOrders();

    isLoading = false;
    notifyListeners();
  }

  List<OrderModel> _getMockPendingOrders() {
    return [
      OrderModel(
        id: '1001',
        title: 'Plumber needed for bathroom leak',
        description: 'Bathroom sink is leaking. Need an experienced plumber to fix it urgently.',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        serviceType: 'Plumbing',
        price: 1200,
        location: 'Mirpur 10, Dhaka',
      ),
      OrderModel(
        id: '1002',
        title: 'Electrician for wiring issues',
        description: 'Need to fix electrical wiring in living room. Facing frequent power trips.',
        status: OrderStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        serviceType: 'Electrical',
        price: 1500,
        location: 'Gulshan 2, Dhaka',
      ),
      OrderModel(
        id: '1003',
        title: 'AC servicing and repair',
        description: 'Air conditioner not cooling properly. Need servicing and possible repair.',
        status: OrderStatus.assigned,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        serviceType: 'AC Repair',
        price: 2000,
        location: 'Banani, Dhaka',
      ),
      OrderModel(
        id: '1004',
        title: 'Home cleaning service',
        description: 'Need full home cleaning including bathrooms, kitchen and living areas.',
        status: OrderStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        serviceType: 'Cleaning',
        price: 1800,
        location: 'Dhanmondi, Dhaka',
      ),
    ];
  }

  List<OrderModel> _getMockReviewOrders() {
    return [
      OrderModel(
        id: '2001',
        title: 'Carpentry work for bedroom',
        description: 'Installed new cabinets and fixed door hinges. Service completed yesterday.',
        status: OrderStatus.toReview,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        serviceType: 'Carpentry',
        price: 3500,
        location: 'Uttara, Dhaka',
      ),
      OrderModel(
        id: '2002',
        title: 'Painting service for living room',
        description: 'Full living room paint job including ceiling and trim.',
        status: OrderStatus.toReview,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        serviceType: 'Painting',
        price: 7500,
        location: 'Bashundhara, Dhaka',
      ),
    ];
  }

  List<OrderModel> _getMockHistoryOrders() {
    return [
      OrderModel(
        id: '3001',
        title: 'Smart TV installation',
        description: 'Wall mounting and setup of 55-inch smart TV with sound system.',
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        serviceType: 'Electronics',
        price: 2200,
        location: 'Mohammadpur, Dhaka',
      ),
      OrderModel(
        id: '3002',
        title: 'Garden landscaping',
        description: 'Landscaping and plant installation for front garden area.',
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        serviceType: 'Gardening',
        price: 4500,
        location: 'Baridhara, Dhaka',
      ),
      OrderModel(
        id: '3003',
        title: 'Refrigerator repair',
        description: 'Refrigerator not cooling properly. Needed compressor check and repair.',
        status: OrderStatus.cancelled,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        serviceType: 'Appliance Repair',
        price: 1800,
        location: 'Malibagh, Dhaka',
      ),
    ];
  }
}