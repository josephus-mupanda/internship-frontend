import 'package:flutter/material.dart';
import '../../core/utils/preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkTheme => _isDarkTheme;

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    _isDarkTheme = Preferences.getIsDarkTheme() ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    await Preferences.setIsDarkTheme(_isDarkTheme);
  }
}
