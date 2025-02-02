import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF3674B5), // Primary: #3674B5
      secondary: Color(0xFF578FCA), // Secondary: #578FCA
      tertiary: Color(0xFFA1E3F9), // Tertiary: #A1E3F9
      background: Color(0xFFD1F8EF), // Complementary background color: #D1F8EF
      surface: Color(0xFFF1F1F1), // Light surface color for cards and containers
      onBackground: Colors.black, // Text color on background
      onSurface: Colors.black, // Text color for surfaces (cards, buttons)
      onPrimary: Colors.white, // Text color on primary buttons/headers
      onSecondary: Colors.white, // Text color on secondary buttons/headers
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Default text color
      headlineMedium: TextStyle(color: Color(0xFF3674B5), fontWeight: FontWeight.bold), // Headline with primary color
      bodyMedium: TextStyle(color: Colors.black), // Text for regular content
      headlineLarge: TextStyle(color: Colors.black), // Large headlines (like for titles)
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF578FCA)), // Use secondary color for labels
      hintStyle: TextStyle(color: Colors.grey), // For input hint text
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF578FCA), width: 2), // Border with secondary color
      ),
    ),
    iconTheme: IconThemeData(color: Color(0xFF578FCA)), // Icons in secondary color
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF3674B5), // Primary button color
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF578FCA), // FAB with secondary color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF3674B5), // AppBar with primary color
      foregroundColor: Colors.white, // AppBar text color
      elevation: 4,
    ),
    cardTheme: CardTheme(
      color: Color(0xFFF1F1F1), // Card background using surface color
      elevation: 4,
      margin: EdgeInsets.all(8),
    ),
    scaffoldBackgroundColor: Color(0xFFD1F8EF), // Set background to complementary color
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF3674B5), // Use primary color for SnackBars
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Color(0xFF3674B5), // Tab label color
      unselectedLabelColor: Color(0xFF578FCA), // Unselected tab label color
      indicatorColor: Color(0xFF3674B5), // Tab indicator color
      labelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold label for selected tab
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF3674B5), // Selected tab
      unselectedItemColor: Color(0xFF578FCA), // Unselected tab
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
      onBackground: Colors.white, // Text color on background
      onSurface: Colors.white, // Text color for surfaces (cards, buttons)
      onPrimary: Colors.white, // Text color on primary buttons/headers
      onSecondary: Colors.white, // Text color on secondary buttons/headers
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Default text color in dark mode
      headlineMedium: TextStyle(color: Color(0xFF3674B5), fontWeight: FontWeight.bold), // Headline with primary color
      bodyMedium: TextStyle(color: Colors.white), // Text for regular content
      headlineLarge: TextStyle(color: Colors.white), // Large headlines (like for titles)
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF578FCA)), // Use secondary color for labels
      hintStyle: TextStyle(color: Colors.grey), // For input hint text
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF578FCA), width: 2), // Border with secondary color
      ),
    ),
    iconTheme: IconThemeData(color: Color(0xFF578FCA)), // Icons in secondary color
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF3674B5), // Primary button color
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF578FCA), // FAB with secondary color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF3674B5), // AppBar with primary color
      foregroundColor: Colors.white, // AppBar text color
      elevation: 4,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF2B2B2B), // Darker card background in dark mode
      elevation: 4,
      margin: EdgeInsets.all(8),
    ),
    scaffoldBackgroundColor: Color(0xFF121212), // Dark background color
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF3674B5), // Use primary color for SnackBars
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Color(0xFF3674B5), // Tab label color
      unselectedLabelColor: Color(0xFF578FCA), // Unselected tab label color
      indicatorColor: Color(0xFF3674B5), // Tab indicator color
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF3674B5), // Selected tab
      unselectedItemColor: Color(0xFF578FCA), // Unselected tab
    ),
  );
}
