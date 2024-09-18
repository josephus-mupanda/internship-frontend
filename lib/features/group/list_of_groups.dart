import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/group_dialog.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../routes/app_routes.dart';
import '../main/components/side_menu.dart';
import 'components/group_card.dart';

class ListOfGroups extends StatefulWidget {

  const ListOfGroups({super.key}) ;

  @override
  _ListOfGroupsState createState() => _ListOfGroupsState();
}

class _ListOfGroupsState extends State<ListOfGroups> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if there are groups and no selected group, then select the first group
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      if (groupProvider.groups.isNotEmpty && groupProvider.selectedGroup == null) {
        groupProvider.selectGroup(groupProvider.groups[0]);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
        color: Theme.of(context).cardColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Search bar
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: InputWidget(
                        hintText: 'Search member here...',
                        keyboardType: TextInputType.name,
                        suffixIcon: IconButton(
                          icon: Icon(
                            FeatherIcons.search,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                          },
                        ),
                        onChanged: (String? value) {},
                        validator: (String? value) {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.chevronDown,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Sort by date",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Icon(
                      FeatherIcons.filter,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {

                    return Consumer<GroupProvider>(
                      builder: (context, groupProvider, child) {
                        //
                        // if (groupProvider.selectedGroup == null && groups.isNotEmpty) {
                        //   groupProvider.selectGroup(groups[0]);
                        // }

                        final isSelected = groupProvider.selectedGroup == groups[index];
                        return GroupCard(
                          isActive: Responsive.isMobile(context) ? false : isSelected, // Responsive.isMobile(context) ? false : index == 0,
                          group: groups[index],
                          press: () {
                            groupProvider.selectGroup(groups[index]);
                            if(Responsive.isMobile(context)) {
                              Navigator.pushNamed(context,
                                AppRoutes.memberScreen,
                                arguments: groups[index],
                              );
                            }
                          },
                        );
                      }
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  _showGroupDialog();},
        child: const Icon(Icons.add),
      )
    );
  }
  void _showGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GroupDialog(
          title: "Create Group",
          content: "Please enter the group details below:",
          nameYes: "Create",
          nameNo: "Cancel",
        );
      },
    );
  }

}
