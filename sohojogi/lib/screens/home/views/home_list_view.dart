import 'package:flutter/material.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/navigation/app_appbar.dart';
import 'package:sohojogi/screens/navigation/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppAppBar(),
      body:  Center(
        child: Text('Home Screen'),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar:  AppNavBar(),
      endDrawer:  AppDrawer(),
    );
  }
}