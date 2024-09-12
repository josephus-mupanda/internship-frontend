import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  // Keys for the preferences
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const _keyUserToken = 'userToken'; // Example for storing user token

  // Initialize SharedPreferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Setter for login status
  static Future setIsLoggedIn(bool isLoggedIn) async {
    await _preferences?.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  // Getter for login status
  static bool? getIsLoggedIn() {
    return _preferences?.getBool(_keyIsLoggedIn);
  }

  // Setter for onboarding status
  static Future setHasSeenOnboarding(bool hasSeen) async {
    await _preferences?.setBool(_keyHasSeenOnboarding, hasSeen);
  }

  // Getter for onboarding status
  static bool? getHasSeenOnboarding() {
    return _preferences?.getBool(_keyHasSeenOnboarding);
  }

  // Example: Setter for a user token
  static Future setUserToken(String token) async {
    await _preferences?.setString(_keyUserToken, token);
  }

  // Example: Getter for a user token
  static String? getUserToken() {
    return _preferences?.getString(_keyUserToken);
  }

  // Method to clear all preferences (for logout)
  static Future clear() async {
    await _preferences?.clear();
  }
}
