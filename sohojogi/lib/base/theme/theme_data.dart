import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: grayColor,

  // Configure color scheme for dark mode
  colorScheme: ColorScheme.dark(
    primary: darkColor,
    secondary: secondaryColor,
    surface: grayColor,
    // Ensure text is legible on dark surfaces
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),

  // AppBar theme for dark mode
  appBarTheme: AppBarTheme(
    backgroundColor: darkColor,
    foregroundColor: Colors.white,
  ),

  // Text theme configuration remains consistent
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),

    headlineLarge: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600),

    titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),

    labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500),
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: Colors.white, // Set background to white

  // Configure color scheme for light mode
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white, // Set surface to white
    // Ensure text is legible on light surfaces
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black, // Set elements to black
  ),

  // AppBar theme to maintain consistency
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.black,
  ),

  // Text theme configuration
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),

    headlineLarge: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600),

    titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),

    labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500),
  ),
);
