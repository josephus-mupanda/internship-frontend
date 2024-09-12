
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/environment.dart';
import '../../core/config/app_config.dart';

import '../models/user.dart';

class UserService {
  final String baseUrl = AppConfig.userUrl;

  // Register a new user
  Future<http.Response> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: Environment.getJsonHeaders(null),
      body: jsonEncode(user.toJson()),
    );
    return response;
  }

  // User login
  Future<http.Response> loginUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: Environment.getJsonHeaders(null),
      body: jsonEncode(user.toJson()),
    );
    return response;
  }

  // Reset password
  Future<http.Response> resetPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: Environment.getJsonHeaders(null),
      body: jsonEncode({'email': email}),
    );
    return response;
  }
  // Change password
  Future<http.Response> changePassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password?token=$token'),
      headers: Environment.getJsonHeaders(null),
      body: jsonEncode({'password': newPassword}),
    );
    return response;
  }

  // Confirm user registration
  Future<http.Response> confirmUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/confirmation?token=$token'),
    );
    return response;
  }
  // Logout user
  Future<http.Response> logoutUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
