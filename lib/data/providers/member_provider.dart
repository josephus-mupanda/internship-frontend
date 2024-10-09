
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/member.dart';

class MemberProvider with ChangeNotifier {

  List<MyMember> _members = [];
  List<MyMember> _membersReceived = [];
  List<MyMember> _membersToReceive = [];

  List<MyMember> _filteredMembersReceived = [];
  List<MyMember> _filteredMembersToReceive = [];

  bool _isLoading = false;

  List<MyMember> get members => _members;
  List<MyMember> get membersReceived => _membersReceived;
  List<MyMember> get membersToReceive => _membersToReceive;

  List<MyMember> get filteredMembersReceived => _filteredMembersReceived;
  List<MyMember> get filteredMembersToReceive => _filteredMembersToReceive;

  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchMembers(int groupId) async {
    notifyListeners();
  }

  void filterMembersReceived(String query) {
    if (query.isEmpty) {
      _filteredMembersReceived = List.from(_membersReceived);
    } else {
      _filteredMembersReceived = _membersReceived.where((member) {
        return member.user!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterMembersToReceive(String query) {
    if (query.isEmpty) {
      _filteredMembersToReceive = List.from(_membersToReceive);
    } else {
      _filteredMembersToReceive = _membersToReceive.where((member) {
        return member.user!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void sortMembersReceived(bool ascending) {
    _filteredMembersReceived.sort((a, b) {
      return ascending ? a.user!.compareTo(b.user!) : b.user!.compareTo(a.user!);
    });
    notifyListeners();
  }

  void sortMembersToReceive(bool ascending) {
    _filteredMembersToReceive.sort((a, b) {
      return ascending ? a.user!.compareTo(b.user!) : b.user!.compareTo(a.user!);
    });
    notifyListeners();
  }

  // Method to set groups and select the first one as default
  void setMembers(List<MyMember> members) {
    _members = members;
    notifyListeners();
  }

  void setMembersReceived(List<MyMember> members) {
    _membersReceived = members;
    notifyListeners();
  }

  void setMembersToReceive(List<MyMember> members) {
    _membersToReceive = members;
    notifyListeners();
  }

}
