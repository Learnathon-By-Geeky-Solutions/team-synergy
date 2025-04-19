import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';
import 'package:sohojogi/screens/navigation/app_appbar.dart';
import 'package:sohojogi/screens/navigation/app_drawer.dart';
import '../view_model/home_view_model.dart';
import '../widgets/body_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        appBar: const AppAppBar(),
        body: const SingleChildScrollView(
          child: HomeBodyContent(),
        ),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: const AppNavBar(currentIndex: 1),
        endDrawer: const AppDrawer(),
      ),
    );
  }
}