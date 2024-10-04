import 'dart:convert';
import 'group.dart';
import 'member.dart';

class Loan {
  final int groupId;
  final double amount;

  Loan({
    required this.groupId,
    required this.amount,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      groupId: json['groupId'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'amount': amount,
    };
  }
}

// Enum for transaction types
enum ReservedAmountType {
  LOAN,DISBURSEMENT,INACTIVE_MEMBER_FEES,MEMBERSHIP_FEES
}

// ReservedAmount model
class ReservedAmount {
  final int id;
  final Group group;
  final MyMember member;
  final double amount;
  final DateTime date;
  final ReservedAmountType type;
  final double originalLoanAmount;

  ReservedAmount({
    required this.id,
    required this.group,
    required this.member,
    required this.amount,
    required this.date,
    required this.type,
    required this.originalLoanAmount
  });

  // Factory method for creating a Transaction from JSON
  factory ReservedAmount.fromJson(Map<String, dynamic> json) {
    return ReservedAmount(
      id: json['id'],
      group: json['group'],
      member: json['member'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: ReservedAmountType.values.firstWhere(
            (e) => e.toString() == 'ReservedAmountType.' + json['type'],
      ),
      originalLoanAmount: json['originalLoanAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group,
      'member': member,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'originalLoanAmount': originalLoanAmount,
    };
  }
}
