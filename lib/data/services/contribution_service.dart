import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';
import '../models/contribution.dart';
import '../../core/config/app_config.dart';

class ContributionService {
  final String baseUrl = AppConfig.contributionUrl;

  // Get all contributions
  Future<http.Response> getAllContributions(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: Environment.getJsonHeaders(token),
    );
    return response;
  }

  // Get contribution by ID
  Future<http.Response> getContributionById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token),
    );
    return response;
  }

  // Create a new contribution
  Future<http.Response> createContribution(Contribution contribution, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(contribution.toJson()),
    );
    return response;
  }

  // Update an existing contribution
  Future<http.Response> updateContribution(String id, Contribution contribution, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(contribution.toJson()),
    );
    return response;
  }

  // Delete a contribution
  Future<http.Response> deleteContribution(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token),
    );
    return response;
  }
}
