import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';

class OrderRequest {
  final String workerId;
  final String title;
  final String description;
  final double totalPrice;
  final String serviceType;
  final String location;
  final List<Map<String, dynamic>> services;
  final DateTime? scheduledAt;

  OrderRequest({
    required this.workerId,
    required this.title,
    required this.description,
    required this.totalPrice,
    required this.serviceType,
    required this.location,
    required this.services,
    this.scheduledAt,
  });
}

class OrderService {
  final _supabase = Supabase.instance.client;
  static const _unauthenticatedError = "User not authenticated";

  // Create a new order
  Future<String?> createOrder(OrderRequest request) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception(_unauthenticatedError);
      }

      final orderResponse = await _supabase.from('orders').insert({
        'user_id': userId,
        'worker_id': request.workerId,
        'title': request.title,
        'description': request.description,
        'status': 'pending',
        'total_price': request.totalPrice,
        'service_type': request.serviceType,
        'location': request.location,
        'scheduled_at': request.scheduledAt?.toIso8601String(),
      }).select('id').single();

      final orderId = orderResponse['id'];

      for (var service in request.services) {
        await _supabase.from('order_services').insert({
          'order_id': orderId,
          'service_id': service['service_id'],
          'quantity': service['quantity'],
          'price': service['price'],
          'subtotal': service['subtotal'],
        });
      }

      await _supabase.from('order_statuses').insert({
        'order_id': orderId,
        'status': 'pending',
        'changed_by': userId,
        'notes': 'Order created',
      });

      await _createNotification(
        userId: request.workerId,
        type: 'newOrder',
        title: 'New Order Request',
        message: 'You have a new order request: ${request.title}',
        relatedId: orderId,
        actionUrl: '/order/$orderId',
      );

      return orderId;
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception(_unauthenticatedError);
      }

      // Update order status
      await _supabase.from('orders').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', orderId);

      // Add status history entry
      await _supabase.from('order_statuses').insert({
        'order_id': orderId,
        'status': status,
        'changed_by': userId,
        'notes': notes ?? 'Status updated to $status',
      });

      // Get order details to create notification
      final orderResponse = await _supabase
          .from('orders')
          .select('user_id, worker_id, title')
          .eq('id', orderId)
          .single();

      final recipientId = userId == orderResponse['user_id']
          ? orderResponse['worker_id']
          : orderResponse['user_id'];

      // Create notification based on status
      String notificationType;
      String notificationTitle;
      String notificationMessage;

      switch (status) {
        case 'confirmed':
          notificationType = 'orderConfirmed';
          notificationTitle = 'Order Confirmed';
          notificationMessage = 'Order "${orderResponse['title']}" has been confirmed';
          break;
        case 'completed':
          notificationType = 'orderCompleted';
          notificationTitle = 'Order Completed';
          notificationMessage = 'Your order has been marked as completed';
          break;
        case 'toReview':
          notificationType = 'orderToReview';
          notificationTitle = 'Review Order';
          notificationMessage = 'Please leave a review for your completed order';
          break;
        default:
          notificationType = 'orderStatusUpdate';
          notificationTitle = 'Order Status Update';
          notificationMessage = 'Your order status has been updated to $status';
      }

      await _createNotification(
        userId: recipientId,
        type: notificationType,
        title: notificationTitle,
        message: notificationMessage,
        relatedId: orderId,
        actionUrl: '/order/$orderId',
      );

      return true;
    } catch (e) {
      debugPrint('Error updating order status: $e');
      return false;
    }
  }

  // Get orders for current user with filtering
  Future<List<OrderModel>> getUserOrders({
    List<String>? statuses,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception(_unauthenticatedError);
      }

      var query = _supabase
          .from('orders')
          .select('*, workers(name, profile_image_url)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);


      final response = await query;

      return response.map<OrderModel>((order) {
        return OrderModel(
          id: order['id'],
          title: order['title'],
          description: order['description'],
          status: _parseOrderStatus(order['status']),
          createdAt: DateTime.parse(order['created_at']),
          serviceType: order['service_type'],
          price: order['total_price'].toDouble(),
          location: order['location'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting user orders: $e');
      return [];
    }
  }

  Future<bool> submitReview({
    required String orderId,
    required double rating,
    required String comment,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception(_unauthenticatedError);
      }

      // Get order details to determine the worker
      final orderResponse = await _supabase
          .from('orders')
          .select('worker_id')
          .eq('id', orderId)
          .single();

      final workerId = orderResponse['worker_id'];

      // Insert review
      await _supabase.from('worker_reviews').insert({
        'worker_id': workerId,
        'user_id': userId,
        'order_id': orderId,
        'rating': rating,
        'comment': comment,
        'date': DateTime.now().toIso8601String(),
      });

      // Create notification for worker about the review
      await _createNotification(
        userId: workerId,
        type: 'newReview',
        title: 'New Review Received',
        message: 'You received a new review with rating $rating/5',
        relatedId: orderId,
      );

      return true;
    } catch (e) {
      debugPrint('Error submitting review: $e');
      return false;
    }
  }

  // Get pending orders
  Future<List<OrderModel>> getPendingOrders() async {
    return getUserOrders(
      statuses: ['pending', 'confirmed', 'assigned', 'accepted'],
    );
  }

  // Get to review orders
  Future<List<OrderModel>> getToReviewOrders() async {
    return getUserOrders(
      statuses: ['toReview'],
    );
  }

  // Get history orders
  Future<List<OrderModel>> getHistoryOrders() async {
    return getUserOrders(
      statuses: ['completed', 'cancelled'],
    );
  }

  // Get order details
  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('*, workers(name, profile_image_url), order_services(*)')
          .eq('id', orderId)
          .single();

      return OrderModel(
        id: response['id'],
        title: response['title'],
        description: response['description'],
        status: _parseOrderStatus(response['status']),
        createdAt: DateTime.parse(response['created_at']),
        serviceType: response['service_type'],
        price: response['total_price'].toDouble(),
        location: response['location'],
      );
    } catch (e) {
      debugPrint('Error getting order details: $e');
      return null;
    }
  }

  // Create notification
  Future<bool> _createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? relatedId,
    String? actionUrl,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'type': type,
        'title': title,
        'message': message,
        'related_id': relatedId,
        'action_url': actionUrl,
        'is_read': false,
      });
      return true;
    } catch (e) {
      debugPrint('Error creating notification: $e');
      return false;
    }
  }

  // Helper to parse order status string to enum
  OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'pending': return OrderStatus.pending;
      case 'confirmed': return OrderStatus.confirmed;
      case 'assigned': return OrderStatus.assigned;
      case 'accepted': return OrderStatus.accepted;
      case 'completed': return OrderStatus.completed;
      case 'cancelled': return OrderStatus.cancelled;
      case 'toReview': return OrderStatus.toReview;
      default: return OrderStatus.pending;
    }
  }

  @visibleForTesting
  OrderStatus parseOrderStatusForTesting(String status) {
    return _parseOrderStatus(status);
  }
}