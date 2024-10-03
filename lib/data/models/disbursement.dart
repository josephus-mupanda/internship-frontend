
class Disbursement {
  final int? id;
  final int groupId;
  final int memberId;
  final double amount;
  final DateTime date;

  Disbursement({
    this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
  });

  factory Disbursement.fromJson(Map<String, dynamic> json) {
    return Disbursement(
      id: json['id'] as int,
      groupId: json['groupId'] as int,
      memberId: json['memberId'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
