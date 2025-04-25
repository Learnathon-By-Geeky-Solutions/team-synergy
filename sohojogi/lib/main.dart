import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/admin/views/database_seeder_view.dart';
import 'package:sohojogi/screens/location/view_model/location_view_model.dart';
import 'package:sohojogi/screens/notification/view_model/notification_view_model.dart';
import 'package:sohojogi/screens/order/view_model/order_view_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';
import 'package:sohojogi/screens/service_searched/view_model/service_searched_view_model.dart';
import 'package:sohojogi/screens/splash/splash_screen.dart';
import 'package:sohojogi/base/theme/theme_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/business_profile/view_model/worker_registration_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceSearchedViewModel()),
        ChangeNotifierProvider(create: (_) => WorkerRegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: const MyApp(),
    ),
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    // This is handled through gradle properties
  }
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



