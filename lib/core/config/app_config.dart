import 'dart:convert';

import 'environment.dart';

class AppConfig {

  static const String userUrl = '${Environment.baseUrl}/api/users';

  static const String groupUrl = '${Environment.baseUrl}/api/groups';

  static const String memberUrl = '${Environment.baseUrl}/api/members';

  static const String contributionUrl = '${Environment.baseUrl}/api/contributions';

  static const String disbursementUrl = '${Environment.baseUrl}/api/disbursements';

  static const String transactionUrl = '${Environment.baseUrl}/api/transactions';

  static const String loanUrl = '${Environment.baseUrl}/api/loans';

}
