import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home/views/home_list_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
          width: 125,
          height: 125,
          child: LottieBuilder.asset('assets/lottie/splash.json'),
        ),
      ),
      nextScreen: const HomeScreen(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 2000,
    );
  }
}