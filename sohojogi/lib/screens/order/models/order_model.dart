// lib/screens/order/models/order_model.dart
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

enum OrderStatus {
  pending,
  confirmed,
  assigned,
  accepted,
  completed,
  cancelled,
  toReview
}

class OrderModel {
  final String id;
  final String title;
  final String description;
  final OrderStatus status;
  final DateTime createdAt;
  final String serviceType;
  final double price;
  final String location;

  OrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.serviceType,
    required this.price,
    required this.location,
  });

  // Helper methods for status display
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.assigned:
        return 'Assigned';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.toReview:
        return 'Review';
    }
  }

  Color getStatusColor(bool isDarkMode) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.green;
      case OrderStatus.assigned:
        return Colors.blue;
      case OrderStatus.accepted:
        return Colors.pink;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.toReview:
        return primaryColor; // Yellow/Gold
    }
  }
}