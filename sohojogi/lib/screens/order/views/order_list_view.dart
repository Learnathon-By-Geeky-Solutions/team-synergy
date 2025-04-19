import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/order/models/order_model.dart';
import 'package:sohojogi/screens/order/widgets/order_card_widget.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  // Order lists for each tab
  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _reviewOrders = [];
  List<OrderModel> _historyOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 1));

    // Load mock data for each tab
    _pendingOrders = _getMockPendingOrders();
    _reviewOrders = _getMockReviewOrders();
    _historyOrders = _getMockHistoryOrders();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // Mock data generators
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

  // Refresh functionality
  Future<void> _onRefresh() async {
    await _loadOrders();
  }

  // Navigate to order details
  void _navigateToOrderDetails(OrderModel order) {
    // Navigation to be implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to order details for: ${order.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDarkMode ? grayColor : const Color(0xFFF9F5F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: isDarkMode ? lightGrayColor : grayColor,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'To Review'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // Pending Orders Tab
          _buildOrderList(_pendingOrders, 'No pending orders', isDarkMode),

          // To Review Orders Tab
          _buildOrderList(_reviewOrders, 'No orders to review', isDarkMode),

          // History Orders Tab
          _buildOrderList(_historyOrders, 'No order history', isDarkMode),
        ],
      ),
        bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders, String emptyMessage, bool isDarkMode) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? lightColor : darkColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: OrderCardWidget(
              order: order,
              onTap: () => _navigateToOrderDetails(order),
            ),
          );
        },
      ),
    );
  }
}