import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/base/theme/theme_data.dart';
import 'package:sohojogi/constants/colors.dart';

void main() {
  group('Theme Data Tests', () {
    test('Light theme has correct properties', () {
      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.primaryColor, equals(primaryColor));
      expect(lightTheme.hintColor, equals(secondaryColor));
      expect(lightTheme.scaffoldBackgroundColor, equals(bgLightColor));
    });

    test('Dark theme has correct properties', () {
      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.primaryColor, equals(primaryColor));
      expect(darkTheme.hintColor, equals(secondaryColor));
      expect(darkTheme.scaffoldBackgroundColor, equals(grayColor));
    });

    test('Text theme font families are consistent between themes', () {
      final lightTextTheme = lightTheme.textTheme;
      final darkTextTheme = darkTheme.textTheme;

      expect(lightTextTheme.bodyLarge?.fontFamily, equals('Poppins'));
      expect(darkTextTheme.bodyLarge?.fontFamily, equals('Poppins'));
      expect(lightTextTheme.headlineLarge?.fontFamily, equals('Poppins'));
      expect(darkTextTheme.headlineLarge?.fontFamily, equals('Poppins'));
    });

    test('Text theme font sizes are consistent between themes', () {
      final lightTextTheme = lightTheme.textTheme;
      final darkTextTheme = darkTheme.textTheme;

      expect(lightTextTheme.bodyLarge?.fontSize, equals(16));
      expect(darkTextTheme.bodyLarge?.fontSize, equals(16));
      expect(lightTextTheme.headlineLarge?.fontSize, equals(24));
      expect(darkTextTheme.headlineLarge?.fontSize, equals(24));
    });

    test('AppBar theme properties are correct', () {
      expect(lightTheme.appBarTheme.backgroundColor, equals(lightColor));
      expect(lightTheme.appBarTheme.foregroundColor, equals(darkColor));
      expect(darkTheme.appBarTheme.backgroundColor, equals(darkColor));
      expect(darkTheme.appBarTheme.foregroundColor, equals(lightColor));
    });

    test('ColorScheme properties are correct', () {
      expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
      expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
      expect(lightTheme.colorScheme.primary, equals(primaryColor));
      expect(darkTheme.colorScheme.primary, equals(primaryColor));
    });
  });
}