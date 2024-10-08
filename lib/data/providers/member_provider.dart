
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/member.dart';

class MemberProvider with ChangeNotifier {
  List<MyMember> _members = [];
  bool _isLoading = false;

  List<MyMember> get members  => _members;
  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to set groups and select the first one as default
  void setMembers(List<MyMember> members) {
    _members = members;
    notifyListeners();
  }

}
