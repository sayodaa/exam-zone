import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _languageCode = 'en';

  ThemeProvider() {
    _loadPreferences();
  }
  
  // Theme Logic
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _saveTheme();
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', isDarkMode ? 'dark' : 'light');
  }

  // Language Logic
  Locale get currentLocale => Locale(_languageCode);

  void changeLanguage(String code) async {
    _languageCode = code;
    notifyListeners();
    await _saveLanguage();
  }

  Future<void> _saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _languageCode);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme
    final themeString = prefs.getString('themeMode') ?? 'dark';
    _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;

    // Load language
    _languageCode = prefs.getString('languageCode') ?? 'en';

    notifyListeners();
  }
}
