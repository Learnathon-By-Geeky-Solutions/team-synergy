import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/ui/login_signup/auth_check.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: auth_check(),
      debugShowCheckedModeBanner: false,
    );
  }
}
