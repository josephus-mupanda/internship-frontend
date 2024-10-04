import 'group.dart';
import 'member.dart';

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
  final Group group;
  final MyMember member;
  final double amount;
  final DateTime date;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.group,
    required this.member,
    required this.amount,
    required this.date,
    required this.type,
  });

  // Factory method for creating a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      group: json['group'],
      member: json['member'],
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
      'group': group,
      'member': member,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }
}