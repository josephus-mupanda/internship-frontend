
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/app_config.dart';

class UserService {
  final String baseUrl = AppConfig.userUrl;

  // Register a new user
  Future<http.Response> registerUser(Map<String, String> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user),
    );
    return response;
  }

  // User login
  Future<http.Response> loginUser(Map<String, String> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(credentials),
    );
    return response;
  }

  // Reset password
  Future<http.Response> resetPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
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

  // Change password
  Future<http.Response> changePassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password?token=$token'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'password': newPassword}),
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
