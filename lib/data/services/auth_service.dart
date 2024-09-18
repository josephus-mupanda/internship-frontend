import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internship_frontend/data/services/user_service.dart';

import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../models/user.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _userService = UserService();

  Future<String?> login(BuildContext context,User user) async {
    final response = await _userService.loginUser(user);
    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      final token = responseBody['token'] as String?;
      final username = responseBody['username'] as String?;
      final email = responseBody['email'] as String?;

      if (token != null && username != null && email != null) {

        await _storage.write(key: 'jwt_token', value: token); // Store securely
        await Preferences.setUserToken(token); // Save the token using Preferences class
        await Preferences.setIsLoggedIn(true); // Set login status to true
        await Preferences.setUsername(username); // Store username
        await Preferences.setEmail(email); // Store email

        return token;
      }
    } else {
      // Check if the widget is still mounted
      if (!context.mounted) return null;
      // Handle login failure
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] as String? ?? 'Login failed';
      if (response.statusCode == 401) {
        // Handle unauthorized
        showErrorToast(context, errorMessage);
      } else if (response.statusCode == 403) {
        // Handle forbidden
        showWarningToast(context, errorMessage);
      } else {
        showErrorToast(context, errorMessage);
      }
    }
    return null;
  }

  Future<void> logout(BuildContext context) async {
    final token = await getAccessToken(); // Get stored token
    if (token != null) {

      final response = await _userService.logoutUser(token); // Call logout API
      if (response.statusCode == 200) {
        await _storage.delete(key: 'jwt_token'); // Remove from secure storage
        await Preferences.clear(); // Clear all SharedPreferences data
        showSuccessToast(context, "Successfully logged out");
      } else {
        // Handle logout error (e.g., show error toast)
        if (!context.mounted) return;
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'] as String? ?? 'Logout failed';
        showErrorToast(context, errorMessage);
      }
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}