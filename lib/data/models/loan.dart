import 'dart:convert';

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
