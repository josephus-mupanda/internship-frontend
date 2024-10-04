
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/environment.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/toast.dart';
import '../models/user.dart';

class UserService {
  final String baseUrl = AppConfig.userUrl;

  // Get user by user ID
  Future<http.Response?> getUserById(int userId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "User not found. Please check the user ID.");
      } else {
        showWarningToast(context, "Failed to retrieve the user . Please try again later.");
      }
    } catch(e){
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
  // Get user by username
  Future<User?> getUserByUsername(String username, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/username/$username'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        // Parse the response body into UserDTO format
        final Map<String, dynamic> userMap = jsonDecode(response.body);
        return User.fromJson(userMap); // Assuming your User model has a `fromJson` method
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "User not found. Please check the username.");
      } else {
        showWarningToast(context, "Failed to retrieve the user. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
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

  // Update user profile
  Future<http.Response?> updateUser(User user, String token, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(user.toJson()), // Convert user object to JSON
      );

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        // Successfully updated the user profile
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "User not found. Please check the user ID.");
      } else if (response.statusCode == 409) {
        showWarningToast(context, "Username already taken. Please choose another username.");
      } else {
        showWarningToast(context, "Failed to update user profile. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
  // Retrieve all users
  Future<http.Response?> getAllUsers(String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "Users not found. Please check the user ID.");
      } else {
        showWarningToast(context, "Failed to retrieve all users . Please try again later.");
      }
    } catch(e){
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // Retrieve all loans by User ID
  Future<http.Response?> getAllLoansByUserId(int userId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/loans'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Check the status code and handle the response
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'User or member not found.');
      } else {
        showWarningToast(context, 'Failed to retrieve loans. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Retrieve all loans by User ID
  Future<http.Response?> getAllTransactionsByUserId(int userId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Check the status code and handle the response
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'User or member not found.');
      } else {
        showWarningToast(context, 'Failed to retrieve transactions. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }
}
