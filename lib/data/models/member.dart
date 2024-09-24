import 'dart:ui';

import 'package:flutter/material.dart';
import 'user.dart';
import 'group.dart';

class Member {
  final int? id;
  final User? user;
  final Group? group;
  final String? roleType;
  final DateTime? joinDate;
  final bool? isActive;
  final Color? tagColor;

    Member({
      this.id,
      this.roleType,
      this.isActive,
      this.joinDate,
      required this.user,
      required this.group,
    }): tagColor = _getTagColor(roleType);

  // Function to determine the color based on the role
  static Color? _getTagColor(String? role) {
    if (role == 'LEADER') {
      return const Color(0xFF23CF91);
    } else if (role == 'MEMBER') {
      return const Color(0xFF3A6FF7);
    }
    return Colors.grey;
  }

    factory Member.fromJson(Map<String,dynamic> json){
      return Member(
        id: json['id'],
        user: User.fromJson(json['user']),
        group: Group.fromJson(json['group']),
        roleType: json['roleType'],
        isActive: json['isActive'],
        joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      );
    }

    Map<String,dynamic> toJson(){
      return {
        'id':id,
        'user': user?.toJson(),
        'group': group?.toJson(),
        'roleType':roleType,
        'isActive':isActive,
        'joinDate': joinDate?.toIso8601String(), // Convert DateTime to string
      };
    }
}

// final List<Member> members = List.generate(
//   memberData.length,
//       (index) {
//     final data = memberData[index];
//     return Member(
//       userId: data['userId'],
//       groupId: data['groupId'],
//       roleType: data['roleType'],
//       isActive: data['isActive'],
//       joinDate: data['joinDate'] != null ? DateTime.parse(data['joinDate']) : null,
//     );
//   },
// );
//
// final List<Map<String, dynamic>> memberData = [
//   {
//     'userId': 1,
//     'groupId': 101,
//     'roleType': 'LEADER',
//     'isActive': true,
//     'joinDate': '2024-08-01T10:00:00.000Z',
//   },
//   {
//     'userId': 2,
//     'groupId': 101,
//     'roleType': 'MEMBER',
//     'isActive': false,
//     'joinDate': '2024-08-05T10:00:00.000Z',
//   },
//   {
//     'userId': 3,
//     'groupId': 102,
//     'roleType': 'LEADER',
//     'isActive': true,
//     'joinDate': '2024-08-10T10:00:00.000Z',
//   },
//   {
//     'userId': 4,
//     'groupId': 102,
//     'roleType': 'MEMBER',
//     'isActive': true,
//     'joinDate': '2024-08-15T10:00:00.000Z',
//   },
//   {
//     'userId': 5,
//     'groupId': 103,
//     'roleType': 'MEMBER',
//     'isActive': false,
//     'joinDate': '2024-08-20T10:00:00.000Z',
//   },
// ];
