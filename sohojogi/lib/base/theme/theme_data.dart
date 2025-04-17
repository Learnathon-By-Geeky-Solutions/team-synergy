import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';

TextTheme _sharedTextTheme = const TextTheme(
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
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: grayColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white,
    onPrimary: lightColor,
    onSecondary: lightColor,
    onSurface: lightColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkColor,
    foregroundColor: lightColor,
  ),
  textTheme: _sharedTextTheme,
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: lightColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: lightColor,
    onPrimary: lightColor,
    onSecondary: lightColor,
    onSurface: darkColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: lightColor,
    foregroundColor: darkColor,
  ),
  textTheme: _sharedTextTheme,
);