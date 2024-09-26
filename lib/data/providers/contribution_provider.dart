
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/contribution.dart';

class ContributionProvider with ChangeNotifier {
  List<Contribution> _contributions = [];
  bool _isLoading = false;

  List<Contribution> get contributions  => _contributions;
  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to set contributions and select the first one as default
  void setContributions(List<Contribution>  contributions) {
    _contributions = contributions;
    notifyListeners();
  }

}
