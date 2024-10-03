class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String confirmEmail = '/confirmation';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';
  static const String dashboard = '/dashboard';


  static const String groupMenuScreen = '$dashboard/groups';
  //========================================================
  static const String allMembersGroupScreen = '$groupMenuScreen/members';
  static const String addMemberInGroupScreen = '$groupMenuScreen/addMember';
  static const String contributionGroupScreen = '$groupMenuScreen/myContribution';
  static const String allContributionsGroupScreen = '$groupMenuScreen/allContributions';
  static const String disbursementScreen = '$groupMenuScreen/disbursements';
  static const String loanGroupScreen = '$groupMenuScreen/myLoan';
  static const String allLoansGroupScreen = '$groupMenuScreen/allLoans';

  static const String loanOnboardingScreen = '$dashboard/loanOnboarding';
  static const String loanScreen = '$dashboard/loan';
// Add more routes as needed
}
