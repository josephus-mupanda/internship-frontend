import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internship_frontend/data/services/user_service.dart';

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
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
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

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}