import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  // Keys for the preferences
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const _keyHasSeenLoanOnboarding = 'hasSeenLoanOnboarding';
  static const _keyUserID = 'userID';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyGroupCreatorUsername = 'groupCreatorUsername';
  static const _keyTheme = 'isDarkTheme';

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

  // Setter for loan onboarding status
  static Future setHasSeenLoanOnboarding(bool hasSeen) async {
    await _preferences?.setBool(_keyHasSeenLoanOnboarding, hasSeen);
  }

  // Getter for loan onboarding status
  static bool? getHasSeenLoanOnboarding() {
    return _preferences?.getBool(_keyHasSeenLoanOnboarding);
  }

  // Example: Setter for a user ID
  static Future setUserId(int userId) async {
    await _preferences?.setInt(_keyUserID, userId);
  }

  // Example: Getter for a user ID
  static int? getUserId() {
    return _preferences?.getInt(_keyUserID);
  }

  // Setter for username
  static Future setUsername(String username) async {
    await _preferences?.setString(_keyUsername, username);
  }

  // Setter for email
  static Future setEmail(String email) async {
    await _preferences?.setString(_keyEmail, email);
  }

  // Getter for email
  static String? getEmail() {
    return _preferences?.getString(_keyEmail);
  }
  // Getter for username
  static String? getUsername() {
    return _preferences?.getString(_keyUsername);
  }

  // Setter for group creator username
  static Future setGroupCreatorUsername(String username) async {
    await _preferences?.setString(_keyGroupCreatorUsername, username);
  }

  // Getter for group creator username
  static String? getGroupCreatorUsername() {
    return _preferences?.getString(_keyGroupCreatorUsername);
  }

  // Setter for theme preference
  static Future setIsDarkTheme(bool isDarkTheme) async {
    await _preferences?.setBool(_keyTheme, isDarkTheme);
  }

  // Getter for theme preference
  static bool? getIsDarkTheme() {
    return _preferences?.getBool(_keyTheme);
  }

  // Method to clear all preferences (for logout)
  static Future clear() async {
    await _preferences?.clear();
  }
}
