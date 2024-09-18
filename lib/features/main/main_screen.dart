import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/layout/responsive_widget.dart';
import '../../data/providers/menu_provider.dart';
import '../group/list_of_groups.dart';
import '../loan/list_of_loans.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<MenuProvider>(
          builder: (context, menuProvider, child) {
            return Responsive(
              // Let's work on our mobile part
              mobile:  Builder(
                builder: (context) {
                  if (menuProvider.selectedItem == MenuItemSelect.GROUPS) {
                    return const ListOfGroups();
                  } else if (menuProvider.selectedItem == MenuItemSelect.LOANS) {
                    return const ListOfLoans();
                  }
                  return menuProvider.getSelectedScreen();
                },
              ),
              tablet: menuProvider.getSelectedScreen(),
              desktop: Row(
                children: [
                  if (_size.width > 1340) const Expanded(flex: 2, child: SideMenu()),
                  if (_size.width <= 1340) const Expanded(flex: 3, child: SideMenu()),
                  if (menuProvider.selectedItem == MenuItemSelect.GROUPS && _size.width > 1340)
                    Expanded(flex: _size.width > 1340 ? 3 : 5, child: const ListOfGroups()),
                  if (menuProvider.selectedItem == MenuItemSelect.LOANS && _size.width > 1340)
                    Expanded(flex: _size.width > 1340 ? 3 : 5, child: const ListOfLoans()),
                  Expanded(flex: _size.width > 1340 ? 8 : 10, child: menuProvider.getSelectedScreen()),
                ],
              ),
            );
          }
      ),
    );
  }
}
