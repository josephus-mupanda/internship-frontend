import 'package:flutter/material.dart';
import 'package:internship_frontend/features/group/group_menu_screen.dart';
import 'package:internship_frontend/features/loan/loan_onboarding_screen.dart';
import 'package:internship_frontend/features/loan/loan_screen.dart';
import 'package:internship_frontend/features/logout/logout_screen.dart';
import '../../core/utils/preferences.dart';
import '../../features/group/empty_group_screen.dart';
import '../../features/group/list_of_groups.dart';
import '../../features/loan/list_of_loans.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/transaction/transaction_screen.dart';
import '../models/group.dart';

enum MenuItemSelect { GROUPS, LOANS, TRANSACTIONS, PROFILE, LOGOUT }

class MenuProvider with ChangeNotifier {

  MenuItemSelect _selectedItem = MenuItemSelect.GROUPS;
  List<Group> groups = [];
  Group? _selectedGroup;
  bool? _hasSeenLoanOnboarding = false;

  MenuItemSelect get selectedItem => _selectedItem;
  Group? get selectedGroup => _selectedGroup;

  void selectItem(MenuItemSelect item) {
    _selectedItem = item;
    notifyListeners();
  }
  void resetSelection() {
    _selectedItem = MenuItemSelect.GROUPS;
    _selectedGroup = null;
    notifyListeners();
  }

  void updateGroups(List<Group> newGroups) {
    groups = newGroups;
    notifyListeners();
  }

  void selectGroup(Group group) {
    _selectedGroup = group;
    notifyListeners();
  }

  // Check onboarding status
  Future<void> checkLoanOnboardingStatus() async {
    _hasSeenLoanOnboarding =  Preferences.getHasSeenLoanOnboarding();
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
              child: _selectedGroup != null
                  ?
              GroupMenuScreen(group: _selectedGroup!):
              const EmptyGroupScreen(),
            ),
          ],
        );
      case MenuItemSelect.LOANS:
        return Row(
          children: [
            const Expanded(flex: 6, child: ListOfLoans()),
            Expanded(
              flex: 9,
              child: _selectedGroup != null
                  ? _hasSeenLoanOnboarding!
                  ? LoanScreen(group: _selectedGroup!)
                  : LoanOnboardingScreen(onboardingComplete: completeLoanOnboarding)
                  : const EmptyGroupScreen(),
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
              child: LogoutScreen(),
            ),
          ],
        );
      default:
        return Row(
          children: [
            const Expanded(flex: 6, child: ListOfGroups()),
            Expanded(
              flex: 9,
              child: _selectedGroup != null
                  ?
              GroupMenuScreen(group: _selectedGroup!):
              const EmptyGroupScreen(),
            ),
          ],
        );
    }
  }
}
