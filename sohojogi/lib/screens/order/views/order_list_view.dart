// lib/screens/order/views/order_list_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? grayColor : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        title: Text(
          'Orders',
          style: TextStyle(
            color: isDarkMode ? lightColor : darkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Orders will be displayed here',
          style: TextStyle(
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(),
    );
  }
}