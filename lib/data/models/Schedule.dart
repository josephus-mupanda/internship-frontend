
class Schedule {
  final String month;
  final String memberUsername;
  final double amount;

  Schedule({
    required this.month,
    required this.memberUsername,
    required this.amount,

  });
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      month: json['month'],
      memberUsername: json['memberUsername'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'memberUsername': memberUsername,
      'amount': amount,
    };
  }
}