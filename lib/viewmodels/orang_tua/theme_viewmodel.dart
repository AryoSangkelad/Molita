import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeViewModel extends ChangeNotifier {
  static const _key = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeViewModel() {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _saveTheme(isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
