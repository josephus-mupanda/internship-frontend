import 'dart:ui';
import 'package:flutter/material.dart';

class Member {
  final int? id;
  final int? userId;
  final int? groupId;
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
  }) : tagColor = _getTagColor(roleType);

  // Function to determine the color based on the role
  static Color? _getTagColor(String? role) {
    if (role == 'LEADER') {
      return const Color(0xFF23CF91); // Green
    } else if (role == 'MEMBER') {
      return const Color(0xFF3A6FF7); // Blue
    }
    return Colors.grey; // Default color for other roles
  }

  // fromJson factory method for JSON deserialization
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      groupId: json['groupId'] as int?,
      roleType: json['roleType'] as String?,
      isActive: json['isActive'] as bool?,
      joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
    );
  }

  // toJson method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'groupId': groupId,
      'roleType': roleType,
      'isActive': isActive,
      'joinDate': joinDate?.toIso8601String(), // Convert DateTime to string
    };
  }
}
