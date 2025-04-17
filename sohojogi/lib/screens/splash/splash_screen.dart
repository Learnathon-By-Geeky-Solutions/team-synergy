import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/authentication/views/signin_view.dart';
import 'package:sohojogi/screens/home/views/home_list_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
          width: 125,
          height: 125,
          // Load different assets based on the brightness
          child: LottieBuilder.asset(
            isDarkMode ? 'assets/lottie/splash_dark.json' : 'assets/lottie/splash.json',
          ),
        ),
      ),
      nextScreen: const SignInView(),
      splashIconSize: 400,
      backgroundColor: backgroundColor,
      duration: 1000,
    );
  }
}