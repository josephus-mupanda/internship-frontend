import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/app_config.dart';

class GroupService {
  final String baseUrl = AppConfig.groupUrl;

  // Fetch all groups
  Future<http.Response> getAllGroups(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Fetch a group by ID
  Future<http.Response> getGroupById(String token, String groupId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$groupId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Create a new group
  Future<http.Response> createGroup(String token, Map<String, dynamic> groupData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(groupData),
    );
    return response;
  }

  // Update a group by ID
  Future<http.Response> updateGroup(String token, String groupId, Map<String, dynamic> groupData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$groupId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(groupData),
    );
    return response;
  }

  // Delete a group by ID
  Future<http.Response> deleteGroup(String token, String groupId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$groupId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Handle inactive members in a group
  Future<http.Response> handleInactiveMembers(String token, String groupId, Map<String, dynamic> memberData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-inactive'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(memberData),
    );
    return response;
  }

  // Handle active members in a group
  Future<http.Response> removeActiveMember(String token, String groupId, Map<String, dynamic> memberData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-active'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(memberData),
    );
    return response;
  }
}
