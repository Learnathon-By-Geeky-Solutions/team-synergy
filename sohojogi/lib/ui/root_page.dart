import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';

import 'chat/chat_page.dart';
import 'home/home_page.dart';
import 'orders/orders_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int bottomNavIndex = 0;

  // list of pages
  List<Widget> pages = [
    const OrdersPage(),
    const HomePage(),
    const ChatPage(),
  ];

  //list of bottom navigation bar icons
  List<IconData> icons = [
    Icons.shopping_cart,
    Icons.home,
    Icons.chat_bubble,
  ];

  //list of bottom navigation bar titles
  List<String> titles = [
    'Orders',
    'Home',
    'Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titles[bottomNavIndex], style:
            TextStyle(color: Constants.secondaryColor,
            fontFamily: Constants.fontFamily,
            fontSize: Constants.titleStyle.fontSize,
            fontWeight: Constants.titleStyle.fontWeight),),

            Row(
              spacing: 20,
              children: [
                Icon(Icons.notifications_none_outlined, color: Constants.secondaryColor, size: 30),
                Icon(Icons.supervised_user_circle , color: Constants.secondaryColor, size: 30),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: IndexedStack(
        // pages, titles, and icons are in the same order
        index: bottomNavIndex,
        children: pages,

      ),
      bottomNavigationBar: CurvedNavigationBar(items: icons.map((e) => Icon(e)).toList(),
        onTap: (index) {
          setState(() {
            bottomNavIndex = index;
          });
        },
        index: bottomNavIndex,
        backgroundColor: Constants.lightColor,
        color: Constants.primaryColor,
        buttonBackgroundColor: Constants.primaryColor,
        height: 75,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
