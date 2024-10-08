class Contribution {
  final int? id;
  final int? groupId;
  final int memberId;
  final double amount;
  final DateTime? date;
  final String? month;
  final int? year;

  Contribution({
    this.id,
    this.groupId,
    required this.memberId,
    required this.amount,
    this.date,
    required this.month,
    required this.year
  });

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      id: json['id'] as int,
      groupId: json['groupId'] as int,
      memberId: json['memberId'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      month: json['month'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'date': date?.toIso8601String(),
      'month': month,
      'year': year,
    };
  }
}


class ContributionM {
  final int id;
  final double amount;
  final DateTime date;
  final String group;
  final String user;

  ContributionM({
    required this.id,
    required this.amount,
    required this.date,
    required this.group,
    required this.user,
  });

  factory ContributionM.fromJson(Map<String, dynamic> json) {
    return ContributionM(
      id: json['id'] ,
      amount: json['amount'],
      date:DateTime.parse(json['date']),
      group: json['group'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'amount': amount,
      'date': date.toIso8601String(),
      'group': group,
      'user': user,
    };
  }
}
