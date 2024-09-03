import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/core/config/app_config.dart';

import '../models/Transaction.dart';

class TransactionService {
  final String baseUrl = AppConfig.transactionUrl;

  // Get all transactions
  Future<http.Response> getAllTransactions(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // Get transaction by ID
  Future<http.Response> getTransactionById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // Create a new transaction
  Future<http.Response> createTransaction(Transaction transaction, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );
    return response;
  }

  // Update an existing transaction
  Future<http.Response> updateTransaction(String id, Transaction transaction, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );
    return response;
  }

  // Delete a transaction
  Future<http.Response> deleteTransaction(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
}
