import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/notification/view_model/notification_view_model.dart';
import 'package:sohojogi/screens/order/view_model/order_view_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';
import 'package:sohojogi/screens/service_searched/view_model/service_searched_view_model.dart';
import 'package:sohojogi/screens/splash/splash_screen.dart';
import 'package:sohojogi/base/theme/theme_data.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceSearchedViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}