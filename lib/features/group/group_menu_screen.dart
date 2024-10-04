import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/providers/menu_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/features/group/components/group_menu_card.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/services/auth_service.dart';
import '../../routes/route_generator.dart';
import 'components/header.dart';
import 'empty_join_group_screen.dart';

class GroupMenuScreen extends StatefulWidget {
  final Group group;

  const GroupMenuScreen({super.key, required this.group});

  @override
  State<GroupMenuScreen> createState() => _GroupMenuScreenState();
}

class _GroupMenuScreenState extends State<GroupMenuScreen> {
  String? _username,_groupCreatorUsername;
  Member? currentMember;

  bool _isLoading = true;
  bool _isInGroup = false;
  bool _loading = true;

  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();

  @override
  void initState() {
    super.initState();
    Group selectedGroup = widget.group;
    _loadUsernameAndMember(selectedGroup);
    _checkUserInGroup();
  }

  // Fetch the username from the token
  Future<void> _loadUsernameAndMember(Group selectedGroup) async {
      try {
        String? token = await _authService.getAccessToken();
        String? username = await _authService.getUsernameFromToken();
        String? creatorUsername = Preferences.getGroupCreatorUsername();
        int? userId =  Preferences.getUserId();

        if (token != null && username != null  && userId != null ) {
          final response = await _groupService.getMemberByUsername(token, selectedGroup.id!, userId, context);
          if (response != null) {
            setState(() {
              _username = username;
              _groupCreatorUsername = creatorUsername;
              currentMember = Member.fromJson(jsonDecode(response.body));
              _isLoading = false;
              // Log current member for debugging
              print('Current Member >>>>>>>>>>>>>>>>>>>>>>>>>>>>>: ${currentMember?.toJson()}');
            });
          }
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showErrorToast(context, "Failed to load user data.");
      }
  }

  // Function to check if the user is in the group
  Future<void> _checkUserInGroup() async {
    String? token = await _authService.getAccessToken();
    int? userId =  Preferences.getUserId();
    if (token == null && userId == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      bool isInGroup = await _groupService.isUserInGroup(widget.group.id!, userId!, token!, context);
      print("isUserInGroup result: $isInGroup");
      if (mounted) {
        setState(() {
          _isInGroup = isInGroup;
          _loading = false;
        });
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred while checking membership.');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final selectedGroup = menuProvider.selectedGroup;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    else if (!_isInGroup) {
      return const EmptyJoinGroupScreen();
    }

    return Scaffold (
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child:  selectedGroup == null
              ?
          const Center(child: Text("Select first a group ...."))
          :
          Column(
            children: [
              GroupHeader(group: selectedGroup),
              const Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.kDefaultPadding),
                  child: Column(
                    children: [
                      GroupMenuCard(
                        icon: Icons.people,
                        iconColor: Colors.blue,
                        title: 'All members',
                        press: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutes.allMembersGroupScreen,
                              arguments: selectedGroup
                          );
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),

                      if (_username == selectedGroup.createdBy) ...[
                        GroupMenuCard(
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          title: 'All Contributions',
                          press: () {
                            Navigator.pushNamed(
                                context,
                                AppRoutes.allContributionsGroupScreen,
                                arguments: selectedGroup
                            );
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                        GroupMenuCard(
                          icon: Icons.money_off,
                          iconColor: Colors.red,
                          title: 'All Loans',
                          press: () {
                            Navigator.pushNamed(
                                context,
                                AppRoutes.allLoansGroupScreen,
                                arguments:selectedGroup
                            );
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                        GroupMenuCard(
                          icon: FeatherIcons.creditCard,
                          iconColor: Colors.teal,
                          title: 'All Transactions',
                          press: () {
                            Navigator.pushNamed(
                                context,
                                AppRoutes.allTransactionsGroupScreen,
                                arguments:selectedGroup
                            );
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                      ],
                      // My Contributions (visible to all users)
                      GroupMenuCard(
                        icon: Icons.history,
                        iconColor: Colors.orange,
                        title: 'My Contributions',
                        press: () {
                          if (currentMember != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.contributionGroupScreen,
                              arguments: MyArguments(selectedGroup, currentMember!),
                            );
                          } else {
                            showErrorToast(context, 'Failed to load current member data.');
                          }
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // My Loans (visible to all users)
                      GroupMenuCard(
                        icon: Icons.monetization_on,
                        iconColor: Colors.purple,
                        title: 'My Loans',
                        press: () {
                          if (currentMember != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.loanGroupScreen,
                              arguments: MyArguments(selectedGroup, currentMember!),
                            );
                          } else {
                            showErrorToast(context, 'Failed to load current member data.');
                          }
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      GroupMenuCard(
                        icon: FeatherIcons.creditCard,
                        iconColor: Colors.limeAccent,
                        title: 'My Transactions',
                        press: () {
                          if (currentMember != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.transactionGroupScreen,
                              arguments: MyArguments(selectedGroup, currentMember!),
                            );
                          } else {
                            showErrorToast(context, 'Failed to load current transaction data.');
                          }
                        },
                      ),
                    ],
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
