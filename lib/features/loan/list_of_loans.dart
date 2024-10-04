import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../data/providers/menu_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/group_service.dart';
import '../../routes/app_routes.dart';
import '../main/components/side_menu.dart';
import 'components/group_card.dart';

class ListOfLoans extends StatefulWidget {

  const ListOfLoans({super.key}) ;

  @override
  _ListOfLoansState createState() => _ListOfLoansState();
}

class _ListOfLoansState extends State<ListOfLoans> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<Group> groups = [];
  List<Group> filteredGroups = [];

  Future<void> fetchGroups() async {

    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    try {
      final response = await _groupService.getAllGroups(token);
      if (response.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response.body);
        List<Group> fetchedGroups = data.map((groupJson) {
          return Group.fromJson(groupJson);
        }).toList();
        // Update your state or provider with the fetched groups
        setState(() {
          groups = fetchedGroups;
          filteredGroups = groups;
          Provider.of<GroupProvider>(context, listen: false).setGroups(groups);

        });
      } else {
        // Handle the error if the status code is not 200
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching groups: $e");
    }
  }

  void filterGroups(String query) {
    setState(() {
      filteredGroups = groups.where((group) {
        return group.name.toLowerCase().contains(query.toLowerCase()) ||
            group.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void sortGroupsByDate(bool ascending) {
    setState(() {
      filteredGroups.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0; // Both are null
        if (a.createdAt == null) return ascending ? 1 : -1; // a is null, b is not
        if (b.createdAt == null) return ascending ? -1 : 1; // b is null, a is not
        return ascending ? a.createdAt!.compareTo(b.createdAt!) : b.createdAt!.compareTo(a.createdAt!);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      if (menuProvider.groups.isNotEmpty && menuProvider.selectedGroup == null) {
        menuProvider.selectGroup(menuProvider.groups[0]);
      }
    });
    fetchGroups();
  }
  Future<void> _onRefresh() async {
    await fetchGroups();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final menuProvider = Provider.of<MenuProvider>(context);

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
                          icon: Icon(Icons.menu,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                      Expanded(
                        child: InputWidget(
                          hintText: 'Search group here...',
                          keyboardType: TextInputType.name,
                          suffixIcon: IconButton(
                            icon: Icon(
                              FeatherIcons.search,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                            onPressed: () {
                            },
                          ),
                          onChanged: (String? value) {
                            filterGroups(value ?? "");
                          },
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
                      const SizedBox(width: 5),
                      Text(
                        "Sort by date",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_upward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        onPressed: () {
                          sortGroupsByDate(true); // Ascending
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        onPressed: () {
                          sortGroupsByDate(false); // Descending
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          final selectedGroup = menuProvider.selectedGroup;
                          final isSelected = selectedGroup == filteredGroups[index];
                          return GroupCard(
                            isActive: Responsive.isMobile(context) ? false : isSelected, // Responsive.isMobile(context) ? false : index == 0,
                            group: filteredGroups[index],
                            press: () {
                              menuProvider.selectGroup(filteredGroups[index]);
                              if(Responsive.isMobile(context)) {
                                Navigator.pushNamed(context, AppRoutes.loanScreen);
                              }
                            },
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
