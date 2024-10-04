import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/config/environment.dart';
import '../../core/utils/toast.dart';
import '../models/loan.dart';

class LoanService {
  final String baseUrl = AppConfig.loanUrl;
  // Request a loan
  Future<http.Response?> requestLoan(Loan loan, String token, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(loan.toJson()),
      );

      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        showSuccessToast(context, responseBody["message"] ?? "Loan requested successfully!");
        return response;
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        showErrorToast(context, responseBody["message"] ?? "Loan request failed.");
      } else if (response.statusCode == 404) {
        final responseBody = jsonDecode(response.body);
        showWarningToast(context, responseBody["message"] ?? "Member or group not found.");
      } else if (response.statusCode == 403) {
        showWarningToast(context, "Unauthorized to request this loan.");
      } else {
        showErrorToast(context, "Unexpected error occurred.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
  // Repay a loan
  Future<http.Response?> repayLoan(Loan loan, String token, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/repay'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(loan.toJson()),
      );
      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        showSuccessToast(context, responseBody["message"] ?? "Loan repaid successfully!");
        return response;
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        showErrorToast(context, responseBody["message"] ?? "Loan repaid failed.");
      } else if (response.statusCode == 404) {
        final responseBody = jsonDecode(response.body);
        showWarningToast(context, responseBody["message"] ?? "Member or group not found.");
      } else if (response.statusCode == 403) {
        showWarningToast(context, "Unauthorized to repay this loan.");
      } else {
        showErrorToast(context, "Unexpected error occurred.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
}
