import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  AppNavBarState createState() => AppNavBarState();
}

class AppNavBarState extends State<AppNavBar> {
  int _selectedIndex = 1; // Set the default selected index to 1 (Home)

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
          children: [
            Icon(
              _selectedIndex == index ? _selectedIconData[index] : _iconData[index],
              size: 30,
              color: _selectedIndex == index ? lightColor : getUnselectedColor(),
            ),
          ],
        );
      }),
      backgroundColor: Colors.transparent,
      color: isDarkMode ? darkColor : lightColor,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      animationDuration: const Duration(milliseconds: 200),
      buttonBackgroundColor: (isDarkMode ? darkColor : primaryColor),
      index: _selectedIndex,
    );
  }
}