import 'package:flutter/material.dart';
import '../../../base/services/order_service.dart';
import '../models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<OrderModel> pendingOrders = [];
  List<OrderModel> reviewOrders = [];
  List<OrderModel> historyOrders = [];

  Future<void> loadOrders() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Load orders from backend only
      pendingOrders = await _orderService.getPendingOrders();
      reviewOrders = await _orderService.getToReviewOrders();
      historyOrders = await _orderService.getHistoryOrders();
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to load orders: ${e.toString()}';
      debugPrint('Error loading orders: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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