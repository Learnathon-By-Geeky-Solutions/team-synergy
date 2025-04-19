import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/views/inbox_list_view.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';

import '../order/views/order_list_view.dart';

class AppNavBar extends StatefulWidget {
  // Add a currentIndex parameter that can be passed by parent screens
  final int currentIndex;

  const AppNavBar({super.key, this.currentIndex = 1});

  @override
  AppNavBarState createState() => AppNavBarState();
}

class AppNavBarState extends State<AppNavBar> {
  late int _selectedIndex;

  final List<IconData> _iconData = [
    Icons.shopping_cart_outlined,
    Icons.home_outlined,
    Icons.chat_outlined,
  ];

  final List<IconData> _selectedIconData = [
    Icons.shopping_cart,
    Icons.home,
    Icons.chat,
  ];

  final List<String> _routeNames = [
    '/orders',
    '/home',
    '/inbox',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with the currentIndex passed from parent
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    Color getUnselectedColor() {
      return isDarkMode ? lightColor : primaryColor;
    }

    return CurvedNavigationBar(
      items: List<Widget>.generate(_iconData.length, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedIndex == index ? _selectedIconData[index] : _iconData[index],
              size: 30,
              color: _selectedIndex == index
                  ? (isDarkMode ? lightColor : darkColor)
                  : getUnselectedColor(),
            ),
          ],
        );
      }),
      backgroundColor: isDarkMode? grayColor : Colors.transparent,
      color: isDarkMode ? darkColor : lightColor,
      onTap: (index) {
        if (_selectedIndex == index) return; // Don't navigate if already on the page

        setState(() {
          _selectedIndex = index;
        });

        // Use named routes for more consistent navigation
        Widget nextScreen;
        switch (index) {
          case 0:
            nextScreen = const OrderListView();
            break;
          case 1:
            nextScreen = const HomeScreen();
            break;
          case 2:
            nextScreen = const InboxListView();
            break;
          default:
            nextScreen = const HomeScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      animationDuration: const Duration(milliseconds: 200),
      buttonBackgroundColor: primaryColor, // Changed from darkColor to grayColor
      index: _selectedIndex,
    );
  }
}