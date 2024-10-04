
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/utils/toast.dart';
import '../models/member.dart'; // Update the path as needed

class MemberService {
  final String baseUrl = AppConfig.memberUrl;

  // Get all members
  Future<http.Response> getAllMembers(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
  // Get a member by ID
  Future<http.Response?> getMemberById(int memberId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$memberId'),
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
        showWarningToast(context, "Member not found. Please check the member ID.");
      } else {
        showWarningToast(context, "Failed to retrieve the member . Please try again later.");
      }
    }
    catch(e){
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // Create a new member
  Future<http.Response> createMember(Member member, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(member.toJson()),
    );
    return response;
  }

  // Update an existing member
  Future<http.Response> updateMember(int id, Member member, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(member.toJson()),
    );
    return response;
  }

  // Delete a member
  Future<http.Response> deleteMember(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // Get transactions by Member ID
}
