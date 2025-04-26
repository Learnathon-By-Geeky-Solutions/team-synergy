import 'package:flutter/material.dart';
import '../../../base/services/order_service.dart';
import '../models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<OrderModel> _allOrders = [];

  // Filtered lists
  List<OrderModel> get pendingOrders => _allOrders.where((order) =>
  order.status == OrderStatus.pending ||
      order.status == OrderStatus.confirmed ||
      order.status == OrderStatus.assigned ||
      order.status == OrderStatus.accepted
  ).toList();

  List<OrderModel> get reviewOrders => _allOrders.where((order) =>
  order.status == OrderStatus.toReview
  ).toList();

  List<OrderModel> get historyOrders => _allOrders.where((order) =>
  order.status == OrderStatus.completed ||
      order.status == OrderStatus.cancelled
  ).toList();

  Future<void> loadOrders() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Load all orders from backend
      _allOrders = await _orderService.getUserOrders();
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to load orders: ${e.toString()}';
      debugPrint('Error loading orders: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Other methods remain the same - accept, complete, review, etc.

  // Accept an order (for worker)
  Future<bool> acceptOrder(String orderId) async {
    return updateOrderStatus(orderId, 'accepted');
  }

  // Complete an order (for worker)
  Future<bool> completeOrder(String orderId) async {
    return updateOrderStatus(orderId, 'completed');
  }

  // Move order to review state (for user)
  Future<bool> markOrderForReview(String orderId) async {
    return updateOrderStatus(orderId, 'toReview');
  }

  // Cancel an order
  Future<bool> cancelOrder(String orderId, String reason) async {
    return updateOrderStatus(orderId, 'cancelled', notes: reason);
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status, {String? notes}) async {
    try {
      final success = await _orderService.updateOrderStatus(
        orderId: orderId,
        status: status,
        notes: notes,
      );

      if (success) {
        await loadOrders(); // Reload orders after status change
      }

      return success;
    } catch (e) {
      debugPrint('Error updating order status: $e');
      return false;
    }
  }

  // Submit a review
  Future<bool> submitReview(String orderId, double rating, String comment) async {
    try {
      // First submit the review
      final success = await _orderService.submitReview(
        orderId: orderId,
        rating: rating,
        comment: comment,
      );

      if (success) {
        // Then move the order to completed state
        await updateOrderStatus(orderId, 'completed');

        // Reload orders to refresh the UI
        await loadOrders();
      }

      return success;
    } catch (e) {
      debugPrint('Error submitting review: $e');
      return false;
    }
  }
}