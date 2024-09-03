import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/loan.dart';

class LoanService {
  final String baseUrl = AppConfig.loanUrl;

  // Request a loan
  Future<http.Response> requestLoan(Loan loan, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loan.toJson()),
    );
    return response;
  }

  // Repay a loan
  Future<http.Response> repayLoan(Loan loan, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/repay'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loan.toJson()),
    );
    return response;
  }
}
