import 'package:flutter/material.dart';
import 'package:social_media/themes/dark_mode.dart';
import 'package:social_media/themes/light_mode.dart';

/*

THEME PROVIDER

This helps us change the app between dark & light mode

*/

class ThemeProvider with ChangeNotifier {
  // Initially, set it as light mode
  ThemeData _themeData = lightMode;

  // Get the current theme
  ThemeData get themeData => _themeData;

  // Is it dark mode currently?
  bool get isDarkMode => _themeData = darkMode;

  // Set the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // Update UI
    notifyListeners();
  }

  // Toggle between dark & light mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
