// lib/screens/navigation/app_route.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/screens/chat/views/inbox_list_view.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart'; // Assuming this is the home screen
import 'package:sohojogi/screens/order/views/order_list_view.dart';

/// Handles routing for the application
class AppRoute {
  // Define route names
  static const String home = '/';
  static const String chat = '/chat';
  static const String orders = '/orders';

  // Generate the route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const InboxListView());
      case orders:
        return MaterialPageRoute(builder: (_) => const OrderListView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Navigate to a route by index (for bottom navigation bar)
  static int getRouteIndex(String routeName) {
    switch (routeName) {
      case home:
        return 0;
      case chat:
        return 1;
      case orders:
        return 2;
      default:
        return 0;
    }
  }

  // Get route name from index (for bottom navigation bar)
  static String getRouteNameFromIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return chat;
      case 2:
        return orders;
      default:
        return home;
    }
  }
}