import 'dart:ui';

import 'package:flutter/material.dart';

class Member {
  final int? id;
  final int? userId,groupId;
  final String? roleType;
  final DateTime? joinDate;
  final bool? isActive;
  final Color? tagColor;

    Member({
      this.id,
      this.roleType,
      this.isActive,
      this.joinDate,
      required this.userId,
      required this.groupId,
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
        userId: json['userId'],
        groupId: json['groupId'],
        roleType: json['roleType'],
        isActive: json['isActive'],
        joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      );
    }

    Map<String,dynamic> toJson(){
      return {
        'id':id,
        'userId': userId,
        'groupId': groupId,
        'roleType':roleType,
        'isActive':isActive,
        'joinDate': joinDate?.toIso8601String(), // Convert DateTime to string
      };
    }
}

