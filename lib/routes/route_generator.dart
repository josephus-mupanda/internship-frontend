import 'package:flutter/material.dart';
import 'package:internship_frontend/features/authentication/screens/confirm_email_screen.dart';
import 'package:internship_frontend/features/contribution/my_contribution_screen.dart';
import 'package:internship_frontend/features/group/group_menu_screen.dart';
import 'package:internship_frontend/features/loan/loan_screen.dart';
import 'package:internship_frontend/features/main/main_screen.dart';
import 'package:internship_frontend/features/main/not_found_screen.dart';
import 'package:internship_frontend/features/member/add_member_screen.dart';
import 'package:internship_frontend/features/transaction/my_transaction_screen.dart';
import 'package:internship_frontend/features/transaction/transaction_group_screen.dart';
import '../data/models/group.dart';
import '../data/models/member.dart';
import '../features/authentication/screens/change_password_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/reset_password_screen.dart';
import '../features/contribution/contribution_screen.dart';
import '../features/disbursement/disbursement_screen.dart';
import '../features/loan/loan_history_screen.dart';
import '../features/loan/my_loan_history_screen.dart';
import '../features/member/member_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case AppRoutes.changePassword:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(token: args),
          );
        }
        return _errorRoute();

      case AppRoutes.confirmEmail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ConfirmEmailScreen(token: args),
          );
        }
        return _errorRoute();
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const MainScreen());

        //=============== GROUP MENU =======================
      case AppRoutes.groupMenuScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => GroupMenuScreen(group: args),
          );
        }
        return _errorRoute();

        //-------- ALL MEMBERS IN A GROUP
      case AppRoutes.allMembersGroupScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => MemberScreen(group: args),
          );
        }
        return _errorRoute();

      //-------- ADD MEMBER IN A GROUP
      case AppRoutes.addMemberInGroupScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => AddMemberScreen(group: args),
          );
        }
        return _errorRoute();

        //-------- ALL CONTRIBUTIONS IN A GROUP
      case AppRoutes.allContributionsGroupScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => ContributionScreen(group: args),
          );
        }
        return _errorRoute();

        //-------- ALL MY CONTRIBUTIONS IN A GROUP
      case AppRoutes.contributionGroupScreen:
        if (args is MyArguments) {
          return MaterialPageRoute(
            builder: (_) => MyContributionScreen(
              group: args.group,
              member: args.member,
            ),
          );
        }
        return _errorRoute();

        //-------- ALL LOANS IN A GROUP
      case AppRoutes.allLoansGroupScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => LoanHistoryScreen(group: args),
          );
        }
        return _errorRoute();
      //-------- ALL MY LOANS IN A GROUP
      case AppRoutes.loanGroupScreen:
        if (args is MyArguments) {
          return MaterialPageRoute(
            builder: (_) => MyLoanHistoryScreen(
              group: args.group,
              member: args.member,
            ),
          );
        }
        return _errorRoute();

      //-------- ALL TRANSACTIONS IN A GROUP
      case AppRoutes.allTransactionsGroupScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => TransactionGroupScreen(group: args),
          );
        }
        return _errorRoute();
      //-------- ALL MY TRANSACTIONS IN A GROUP
      case AppRoutes.transactionGroupScreen:
        if (args is MyArguments) {
          return MaterialPageRoute(
            builder: (_) => MyTransactionScreen(
              group: args.group,
              member: args.member,
            ),
          );
        }
        return _errorRoute();

       //-------- ALL DISBURSEMENTS IN A GROUP
      case AppRoutes.disbursementScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => DisbursementScreen(group: args),
          );
        }
        return _errorRoute();

      case AppRoutes.loanScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => LoanScreen(group: args),
          );
        }
        return _errorRoute();

      case AppRoutes.loanOnboardingScreen:
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => LoanScreen(group: args),
          );
        }
        return _errorRoute();

      // case AppRoutes.loanOnboardingScreen:
      //   if (args is Group) {
      //     return MaterialPageRoute(
      //       builder: (_) => LoanScreen(group: args),
      //     );
      //   }
      //   return _errorRoute();

        // return MaterialPageRoute(builder: (_) => LoanOnboardingScreen(
        //   onboardingComplete: () {  },)
        // );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const NotFoundScreen();
    });
  }
}

class MyArguments {
  final Group group;
  final MyMember member;

  MyArguments(this.group, this.member);
}
