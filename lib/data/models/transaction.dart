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
  final double amount;
  final DateTime date;
  final String transactionType;
  final String group;
  final String user;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.transactionType,
    required this.group,
    required this.user,
  });

  // Factory method for creating a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      transactionType:json['transactionType'],
      group: json['group'],
      user: json['user'],
    );
  }

  // Method for converting a Transaction object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': transactionType,
      'group': group,
      'user': user,
    };
  }
}