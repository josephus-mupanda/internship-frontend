import 'package:flutter/material.dart';
import '../models/Schedule.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedule = [];

  List<Schedule> get schedule  => _schedule;

  void setSchedule(List<Schedule> schedule) {
    _schedule = schedule;
    notifyListeners();
  }

  Future<void> fetchSchedule(int groupId) async {
    notifyListeners();
  }

}
