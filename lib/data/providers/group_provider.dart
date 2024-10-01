import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/group.dart';

class GroupProvider with ChangeNotifier {
  Group? _selectedGroup;
  List<Group>? _groups ;
  bool _isLoading = false;

  Group? get selectedGroup => _selectedGroup;
  List<Group> get groups => _groups ?? [];
  bool get isLoading => _isLoading;

  // Method to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  // Method to set groups and select the first one as default
  void setGroups(List<Group> groups) {
    _groups = groups;
    if (_groups!.isNotEmpty && _selectedGroup == null) {
      _selectedGroup = _groups![0]; // Automatically select the first group by default
    }
    notifyListeners();
  }

  // Method to select a specific group
  void selectGroup(Group group) {
    _selectedGroup = group;
    notifyListeners();
  }

  // Method to clear the selected group
  void clearSelection() {
    _selectedGroup = null;
    notifyListeners();
  }
}
