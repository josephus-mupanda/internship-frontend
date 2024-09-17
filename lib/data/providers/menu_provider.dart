import 'package:flutter/material.dart';
import 'package:outlook/screens/group/member_screen.dart';
import 'package:outlook/screens/loan/list_of_loans.dart';
import 'package:outlook/screens/transaction/transaction_screen.dart';
import 'package:outlook/screens/profile/profile_screen.dart';
import 'package:outlook/screens/group/list_of_groups.dart';
import '../../../models/Group.dart';

enum MenuItemSelect { GROUPS, LOANS, TRANSACTIONS, PROFILE, LOGOUT }

class MenuProvider with ChangeNotifier {

  MenuItemSelect _selectedItem = MenuItemSelect.GROUPS;

  MenuItemSelect get selectedItem => _selectedItem;

  void selectItem(MenuItemSelect item) {
    _selectedItem = item;
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
            const Expanded(flex: 6, child: ListOfLoans()), // Replace with your ListOfLoans widget
            Expanded(
              flex: 9,
              child: Container(), // Replace with your LoanScreen or another relevant widget
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
