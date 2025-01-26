import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightColor,
      body: const Center(
        child: Text('This is the orders page'),
      ),
    );
  }
}