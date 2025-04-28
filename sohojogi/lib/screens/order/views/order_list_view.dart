import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../view_model/order_view_model.dart';
import '../widgets/order_card_widget.dart';
import '../../../constants/colors.dart';
import '../../navigation/app_navbar.dart';
import 'order_detail_view.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderViewModel>(context, listen: false).loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context);
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
        title: const Text('Orders'),
        elevation: 0, // Remove app bar shadow
      ),
      body: Column(
        children: [
          // Custom TabBar outside of AppBar
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: isDarkMode ? lightGrayColor : grayColor,
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'To Review'),
                Tab(text: 'History'),
              ],
            ),
          ),
          // TabBarView in Expanded to fill remaining space
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(viewModel.pendingOrders, 'No pending orders', isDarkMode),
                _buildOrderList(viewModel.reviewOrders, 'No orders to review', isDarkMode),
                _buildOrderList(viewModel.historyOrders, 'No order history', isDarkMode),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }

  _buildOrderList(List<OrderModel> orders, String emptyMessage, bool isDarkMode) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: isDarkMode ? lightGrayColor : grayColor,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrderCardWidget(
            order: orders[index],
            onTap: () {
              // Navigate to order details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailView(
                    order: orders[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}