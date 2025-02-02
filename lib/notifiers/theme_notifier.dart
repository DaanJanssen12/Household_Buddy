import 'package:flutter/material.dart';
import 'package:household_buddy/services/user_preference_service.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeNotifier() {
    checkTheme();
  }

  void checkTheme() async {
    var theme = await getUserPreference('theme');
    switch (theme) {
      case 'dark':
        if(!_isDarkMode) toggleTheme();
      default:
        if(_isDarkMode) toggleTheme();
    }
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
