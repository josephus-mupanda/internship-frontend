
import 'group.dart';
import 'member.dart';

class Contribution {
  final int? id;
  final int? groupId;
  final int memberId;
  final double amount;
  final DateTime? date;
  // final String? groupName;
  // final String? memberName;
  Contribution({
    this.id,
    this.groupId,
    required this.memberId,
    required this.amount,
    this.date,
    // this.groupName,  // New field
    // this.memberName, // New field
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      id: json['id'] as int,
      groupId: json['groupId'] as int,
      memberId: json['memberId'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      // groupName: json['groupName'] as String?,   // Extract groupName
      // memberName: json['memberName'] as String?, // Extract memberName
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'date': date?.toIso8601String(),
      // 'groupName': groupName,    // Include groupName in JSON
      // 'memberName': memberName,  // Include memberName in JSON
    };
  }
}


class ContributionM {
  final int id;
  final Group group;
  final MyMember member;
  final double amount;
  final DateTime date;

  ContributionM({
    required this.id,
    required this.group,
    required this.member,
    required this.amount,
    required this.date,
  });

  factory ContributionM.fromJson(Map<String, dynamic> json) {
    return ContributionM(
      id: json['id'] ,
      group: json['group'],
      member: json['member'],
      amount: json['amount'],
      date:DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'group': group,
      'member': member,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
