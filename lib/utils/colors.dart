import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE); // Example purple
  static const Color secondary = Color(0xFF03DAC6); // Example teal
  static const Color background = Color(0xFFF5F5F5); // Light gray background
  static const Color error = Color(0xFFB00020); // Red error color
  static const Color theme = Color(0xFF0000FF); // Pure blue color

  // Define shades using MaterialColor if needed
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF6200EE,
    <int, Color>{
      50: Color(0xFFEDE7F6),
      100: Color(0xFFD1C4E9),
      200: Color(0xFFB39DDB),
      300: Color(0xFF9575CD),
      400: Color(0xFF7E57C2),
      500: Color(0xFF673AB7),
      600: Color(0xFF5E35B1),
      700: Color(0xFF512DA8),
      800: Color(0xFF4527A0),
      900: Color(0xFF311B92),
    },
  );

  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF03DAC6, // Base teal color
    <int, Color>{
      50: Color(0xFFE0F7F4),
      100: Color(0xFFB3EDEA),
      200: Color(0xFF80E2DF),
      300: Color(0xFF4DD6D4),
      400: Color(0xFF26CCCA),
      500: Color(0xFF03DAC6),
      600: Color(0xFF02C2B1),
      700: Color(0xFF02A59B),
      800: Color(0xFF028884),
      900: Color(0xFF01635E),
    },
  );
  static const MaterialColor backgroundSwatch = MaterialColor(
    0xFFF5F5F5, // Base light gray color
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFEFE),
      200: Color(0xFFFFFEFD),
      300: Color(0xFFFFFEFC),
      400: Color(0xFFFDFDFC),
      500: Color(0xFFF5F5F5),
      600: Color(0xFFEBEBEB),
      700: Color(0xFFE1E1E1),
      800: Color(0xFFD7D7D7),
      900: Color(0xFFCCCCCC),
    },
  );
  static const MaterialColor errorSwatch = MaterialColor(
    0xFFB00020, // Base red error color
    <int, Color>{
      50: Color(0xFFFFEDEE),
      100: Color(0xFFFFD2D5),
      200: Color(0xFFFFB6BA),
      300: Color(0xFFFF9AA0),
      400: Color(0xFFFF8087),
      500: Color(0xFFB00020),
      600: Color(0xFFA8001E),
      700: Color(0xFF9E001B),
      800: Color(0xFF940019),
      900: Color(0xFF880017),
    },
  );
  static const MaterialColor themeSwatch = MaterialColor(
    0xFF0000FF, // Base blue color
    <int, Color>{
      50: Color(0xFFE3E3FF),
      100: Color(0xFFB8B8FF),
      200: Color(0xFF8C8CFF),
      300: Color(0xFF6060FF),
      400: Color(0xFF3A3AFF),
      500: Color(0xFF0000FF),
      600: Color(0xFF0000E5),
      700: Color(0xFF0000CC),
      800: Color(0xFF0000B2),
      900: Color(0xFF000099),
    },
  );
}
