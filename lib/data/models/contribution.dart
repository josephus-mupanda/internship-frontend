
class Contribution {
  final int? id;
  final int? groupId;
  final int memberId;
  final double amount;
  final DateTime? date;

  Contribution({
    this.id,
    this.groupId,
    required this.memberId,
    required this.amount,
    this.date,
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
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
      'date': date?.toIso8601String(),
    };
  }
}
