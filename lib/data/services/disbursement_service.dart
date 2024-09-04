import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/environment.dart';
import '../models/disbursement.dart';
import '../../core/config/app_config.dart';

class DisbursementService {
  final String baseUrl = AppConfig.disbursementUrl;

  // Get all disbursements
  Future<http.Response> getAllDisbursements(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: Environment.getJsonHeaders(token),
    );
    return response;
  }

  // Get disbursement by ID
  Future<http.Response> getDisbursementById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token),
    );
    return response;
  }

  // Create a new disbursement
  Future<http.Response> createDisbursement(Disbursement disbursement, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(disbursement.toJson()),
    );
    return response;
  }

  // Update an existing disbursement
  Future<http.Response> updateDisbursement(String id, Disbursement disbursement, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(disbursement.toJson()),
    );
    return response;
  }

  // Delete a disbursement
  Future<http.Response> deleteDisbursement(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: Environment.getJsonHeaders(token)
    );
    return response;
  }
}
