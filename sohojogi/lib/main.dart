import 'package:flutter/material.dart';
import 'package:sohojogi/base/theme/theme_data.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // Disable the debug banner
      debugShowCheckedModeBanner: false,

      // Light theme configuration
      theme: lightTheme,

      // Dark theme configuration
      darkTheme: darkTheme,

      // Automatically switch between light and dark themes based on system settings
      themeMode: ThemeMode.system,

      home: const SplashScreen(),
    );

  }
}
