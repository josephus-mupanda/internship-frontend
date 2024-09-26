
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/loan.dart';

class LoanProvider with ChangeNotifier {
  List<Loan> _loans = [];
  bool _isLoading = false;

  List<Loan> get loans  => _loans;
  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to set loans and select the first one as default
  void setLoans(List<Loan>  loans) {
    _loans = loans;
    notifyListeners();
  }

}
