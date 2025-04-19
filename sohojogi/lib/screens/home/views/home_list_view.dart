import 'package:flutter/material.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/navigation/app_appbar.dart';
import 'package:sohojogi/screens/navigation/app_drawer.dart';

import '../widgets/body_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      body: const SingleChildScrollView(
        child: HomeBodyContent(),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const AppNavBar(),
      endDrawer: const AppDrawer(),
    );
  }
}