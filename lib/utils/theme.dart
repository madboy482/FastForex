import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ThemePreference {
  static Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.PREFS_DARK_THEME) ?? false;
  }

  static Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.PREFS_DARK_THEME, value);
  }

  static ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blueAccent,
      colorScheme: ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.blueAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueAccent,
      colorScheme: ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.blueAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}