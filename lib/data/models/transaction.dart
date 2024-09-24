//
// class Transaction {
//   final int groupId;
//   final int memberId;
//   final double amount;
//   final DateTime date;
//
//   Transaction({
//     required this.groupId,
//     required this.memberId,
//     required this.amount,
//     required this.date,
//   });
//
//   // Create a Transaction instance from JSON
//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       groupId: json['groupId'],
//       memberId: json['memberId'],
//       amount: (json['amount'] as num).toDouble(),
//       date: DateTime.parse(json['date']),
//     );
//   }
//
//   // Convert a Transaction instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'groupId': groupId,
//       'memberId': memberId,
//       'amount': amount,
//       'date': date.toIso8601String(),
//     };
//   }
// }

import 'package:flutter/material.dart';

// Enum for transaction types
enum TransactionType {
  CONTRIBUTION,
  DISBURSEMENT,
  LOAN_REPAYMENT_FEES,
  MEMBERSHIP_FEES,
  INACTIVE_MEMBER_FEES
}

// Transaction model
class Transaction {
  final int id;
  final int groupId;
  final int memberId;
  final double amount;
  final DateTime date;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
    required this.type,
  });

  // Factory method for creating a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      groupId: json['groupId'],
      memberId: json['memberId'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.' + json['type'],
      ),
    );
  }

  // Method for converting a Transaction object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }

}
final List<Transaction> transactions = List.generate(
  transactionData.length,
      (index) {
    final data = transactionData[index];
    return Transaction(
      id: data['id'],
      groupId: data['groupId'],
      memberId: data['memberId'],
      amount: data['amount'],
      date: DateTime.parse(data['date']),
      type: TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.' + data['type'],
      ),
    );
  },
);

// Example JSON data for transactions
final List<Map<String, dynamic>> transactionData = [
  {
    'id': 1,
    'groupId': 101,
    'memberId': 201,
    'amount': 100.0,
    'date': '2024-08-01',
    'type': 'CONTRIBUTION',
  },
  {
    'id': 2,
    'groupId': 101,
    'memberId': 202,
    'amount': 200.0,
    'date': '2024-08-05',
    'type': 'DISBURSEMENT',
  },
  {
    'id': 3,
    'groupId': 102,
    'memberId': 203,
    'amount': 150.0,
    'date': '2024-08-10',
    'type': 'LOAN_REPAYMENT_FEES',
  },
];

