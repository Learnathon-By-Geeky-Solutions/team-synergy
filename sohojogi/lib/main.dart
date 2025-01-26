import 'package:flutter/material.dart';
import 'package:sohojogi/ui/home/home_page.dart';
import 'package:sohojogi/ui/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
