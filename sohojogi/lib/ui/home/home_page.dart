import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightColor,
      body: const Center(
        child: Text('This is the home page'),
      ),
    );
  }
}

