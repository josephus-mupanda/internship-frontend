
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions  => _transactions;
  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  void setTransactions(List<Transaction>  transactions) {
    _transactions = transactions;
    notifyListeners();
  }

}
