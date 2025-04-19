import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/notification/models/notification_model.dart';
import 'package:sohojogi/screens/notification/widgets/notification_card_widget.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({super.key});

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - would be replaced with API/database call
      final notifications = _getMockNotifications();

      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load notifications. Please try again.';
        });
      }
    }
  }

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.orderAccepted,
        title: 'Order Accepted',
        message: 'Your order for plumbing service has been accepted by the service provider.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionUrl: '/order/123',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.confirmOrder,
        title: 'Confirm Your Order',
        message: 'Please confirm your order for electrical repair service within 24 hours.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        actionUrl: '/order/124',
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.orderAssigned,
        title: 'Service Provider Assigned',
        message: 'John Doe has been assigned to your cleaning order. They will arrive at the scheduled time.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        actionUrl: '/order/125',
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.orderCompleted,
        title: 'Order Completed',
        message: 'Your AC repair service has been completed. Please leave a review for the service provider.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        actionUrl: '/order/126',
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.orderCancelled,
        title: 'Order Cancelled',
        message: 'Your painting service order has been cancelled as requested.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        actionUrl: '/order/127',
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.announcement,
        title: 'Holiday Notice',
        message: 'Our services will be limited during the upcoming holiday weekend. Please plan accordingly.',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ];
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark notification as read
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          actionUrl: notification.actionUrl,
          isRead: true,
        );
      }
    });

    // Navigate based on notification type
    // This would be implemented based on your app's navigation structure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening details for: ${notification.title}')),
    );
  }

  Future<void> _onRefresh() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(isDarkMode),
      bottomNavigationBar: const AppNavBar(),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return _buildErrorState(isDarkMode);
    }

    if (_notifications.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return NotificationCardWidget(
            notification: _notifications[index],
            onTap: () => _handleNotificationTap(_notifications[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You\'ll be notified about your orders and announcements',
              style: TextStyle(
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _loadNotifications,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}