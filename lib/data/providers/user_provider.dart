import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<User> _users = [];

  User? get user => _user;
  List<User> get users  => _users;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

}
