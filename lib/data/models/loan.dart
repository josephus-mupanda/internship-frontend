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
  final double amount;
  final DateTime date;
  final String reservedAmountType;
  final String group;
  final String user;
  final double originalLoanAmount;

  ReservedAmount({
    required this.id,
    required this.amount,
    required this.date,
    required this.reservedAmountType,
    required this.group,
    required this.user,
    required this.originalLoanAmount
  });

  // Factory method for creating a Transaction from JSON
  factory ReservedAmount.fromJson(Map<String, dynamic> json) {
    return ReservedAmount(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      reservedAmountType: json['reservedAmountType'],
      group: json['group'],
      user: json['user'],
      originalLoanAmount: json['originalLoanAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': reservedAmountType,
      'group': group,
      'user': user,
      'originalLoanAmount': originalLoanAmount,
    };
  }
}
