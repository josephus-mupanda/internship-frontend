import 'package:flutter/material.dart';
import 'package:internship_frontend/features/loan/loan_onboarding_screen.dart';
import 'package:internship_frontend/features/loan/loan_screen.dart';
import '../../core/utils/preferences.dart';
import '../../features/group/list_of_groups.dart';
import '../../features/loan/list_of_loans.dart';
import '../../features/member/member_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/transaction/transaction_screen.dart';
import '../models/group.dart';

enum MenuItemSelect { GROUPS, LOANS, TRANSACTIONS, PROFILE, LOGOUT }

class MenuProvider with ChangeNotifier {

  MenuItemSelect _selectedItem = MenuItemSelect.GROUPS;
  List<Group> groups = [];
  bool? _hasSeenLoanOnboarding = false;

  MenuItemSelect get selectedItem => _selectedItem;

  void selectItem(MenuItemSelect item) {
    _selectedItem = item;
    notifyListeners();
  }
  void resetSelection() {
    _selectedItem = MenuItemSelect.GROUPS;
    notifyListeners();
  }

  void updateGroups(List<Group> newGroups) {
    groups = newGroups;
    notifyListeners();
  }

  // Check onboarding status
  Future<void> checkLoanOnboardingStatus() async {
    _hasSeenLoanOnboarding = await Preferences.getHasSeenLoanOnboarding();
    notifyListeners();
  }

  // Function to complete onboarding
  Future<void> completeLoanOnboarding() async {
    await Preferences.setHasSeenLoanOnboarding(true);
    _hasSeenLoanOnboarding = true;
    notifyListeners();
  }


  Widget getSelectedScreen() {
    switch (_selectedItem) {
      case MenuItemSelect.GROUPS:
        return Row(
          children: [
            const Expanded(flex: 6, child: ListOfGroups()),
            Expanded(
              flex: 9,
              child: groups.isNotEmpty ? MemberScreen(group: groups[0]) : Container(),
            ),
          ],
        );
      case MenuItemSelect.LOANS:
        return Row(
          children: [
            const Expanded(flex: 6, child: ListOfLoans()),
            Expanded(
              flex: 9,
              child: groups.isNotEmpty
                  ? _hasSeenLoanOnboarding!
                  ? LoanScreen(group: groups[0])
                  : LoanOnboardingScreen(onboardingComplete: completeLoanOnboarding)
                  : Container(),
            ),
          ],
        );
      case MenuItemSelect.TRANSACTIONS:
        return const Row(
          children: [
            Expanded(
              flex: 12,
              child: TransactionScreen(), // Replace with your TransactionScreen widget
            ),
          ],
        );
      case MenuItemSelect.PROFILE:
        return const Row(
          children: [
            Expanded(
              flex: 12,
              child: ProfileScreen(), // Replace with your ProfileScreen widget
            ),
          ],
        );
      case MenuItemSelect.LOGOUT:
        return const Row(
          children: [
            Expanded(
              flex: 12,
              child: ProfileScreen(), // Replace with your ProfileScreen widget
            ),
          ],
        );
      default:
        return Row(
          children: [
            const Expanded(flex: 6, child: ListOfGroups()),
            Expanded(
              flex: 9,
              child: groups.isNotEmpty ? MemberScreen(group: groups[0]) : Container(),
            ),
          ],
        );
    }
  }
}
