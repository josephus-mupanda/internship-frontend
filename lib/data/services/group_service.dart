import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/config/environment.dart';
import '../../core/utils/toast.dart';
import '../models/group.dart';

class GroupService {
  final String baseUrl = AppConfig.groupUrl;

  // Create a new group
  Future<http.Response?> createGroup(Group group, String token,BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(group.toJson()),
      );
      if (!context.mounted) return null;
      // Check the status code and handle conditions with toast messages
      if (response.statusCode == 201) {
        showSuccessToast(context, "Group created successfully!");
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else {
        showWarningToast(context, "Failed to create the group. Please try again later.");
      }
      return response;
    } catch (e) {
      // Handle any exceptions and show error toast
      showErrorToast(context, "An error occurred. Please check your connection.");
      //throw Exception("Failed to create group: $e");
    }
    return null;
  }

  // Update an existing group
  Future<http.Response> updateGroup(int id,Group group, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(group.toJson()),
    );
    return response;
  }

  // Retrieve all groups
  Future<http.Response> getAllGroups(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Retrieve a single group by ID
  Future<http.Response> getGroupById(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
  // Handle inactive members
  Future<http.Response> handleInactiveMembers(
      int groupId, Map<String, dynamic> requestDTO, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-inactive'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(requestDTO),
    );
    return response;
  }

  // Handle active members
  Future<http.Response> handleActiveMembers(
      int groupId, Map<String, dynamic> requestDTO, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-active'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(requestDTO),
    );
    return response;
  }

  // Get members by group
  Future<http.Response> getMembersByGroup(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId/members'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Get contributions by group
  Future<http.Response> getContributionsByGroup(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId/contributions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Get transactions by group
  Future<http.Response> getAllTransactions(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId/transactions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Calculate total loans for a group
  Future<http.Response> getTotalLoanAmount(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId/loans/total'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Calculate total contributions for a group
  Future<http.Response> calculateTotalContributions(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId/contributions/total'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Automate disbursement
  Future<http.Response> automateDisbursement(int groupId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/automate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Add new member after rotation
  Future<http.Response> addNewMemberAfterRotation(
      Map<String, dynamic> newMemberDTO, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-new-member'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(newMemberDTO),
    );
    return response;
  }
}
