
class Transaction {
  final int groupId;
  final int memberId;
  final double amount;
  final DateTime date;

  Transaction({
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
  });

  // Create a Transaction instance from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      groupId: json['groupId'],
      memberId: json['memberId'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  // Convert a Transaction instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
