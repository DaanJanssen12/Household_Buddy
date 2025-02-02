import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF3674B5), // Primary: #3674B5
      secondary: Color(0xFF578FCA), // Secondary: #578FCA
      tertiary: Color(0xFFA1E3F9), // Tertiary: #A1E3F9
      background: Color(0xFFFFFFFF), // Background color
      surface: Color(0xFFF1F1F1), // Surface color for cards and containers
      onBackground: Colors.black, // Text color for background
      onSurface: Colors.black, // Text color for surfaces (cards, buttons)
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Default text color
      headlineMedium: TextStyle(color: Colors.black), // For titles and headers
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black), // Make labels visible
      hintStyle: TextStyle(color: Colors.grey), // For input hint text
    ),
    iconTheme: IconThemeData(color: Colors.black), // Icons in light mode
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF3674B5), // Button color
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3674B5),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF3674B5), // Primary: #3674B5
      secondary: Color(0xFF578FCA), // Secondary: #578FCA
      tertiary: Color(0xFFA1E3F9), // Tertiary: #A1E3F9
      background: Color(0xFF121212), // Dark background color
      surface: Color(0xFF1E1E1E), // Surface color for cards and containers
      onBackground: Colors.white, // Text color for background
      onSurface: Colors.white, // Text color for surfaces (cards, buttons)
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Default text color in dark mode
      headlineMedium: TextStyle(color: Colors.white), // For titles and headers
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white), // Make labels visible
      hintStyle: TextStyle(color: Colors.grey), // For input hint text
    ),
    iconTheme: IconThemeData(color: Colors.white), // Icons in dark mode
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF3674B5), // Button color for dark mode
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3674B5),
    ),
  );
}
