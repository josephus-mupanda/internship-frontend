import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../data/services/auth_service.dart';
import '../../data/services/group_service.dart';
import '../../routes/app_routes.dart';
import '../main/components/side_menu.dart';
import '../member/member_screen.dart';
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
        // Convert the JSON data into a list of Group objects
        List<Group> fetchedGroups = data.map((groupJson) {
          return Group.fromJson(groupJson);
        }).toList();
        // Update your state or provider with the fetched groups
        setState(() {
          groups = fetchedGroups;
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
    fetchGroups();
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberScreen(group: groups[index]),
                                      ),
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

    );
  }
}
