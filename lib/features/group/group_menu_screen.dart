import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/features/group/components/group_menu_card.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/providers/group_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/member_service.dart';
import '../../routes/route_generator.dart';
import 'components/header.dart';

class GroupMenuScreen extends StatefulWidget {
  final Group group;

  const GroupMenuScreen({super.key, required this.group,});

  @override
  State<GroupMenuScreen> createState() => _GroupMenuScreenState();
}

class _GroupMenuScreenState extends State<GroupMenuScreen> {
  String? _username,_groupCreatorUsername;
  Member? currentMember;

  bool _isLoading = true;
  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();

  @override
  void initState() {
    super.initState();
    _loadUsernameAndMember();
  }
  // Fetch the username from the token
  Future<void> _loadUsernameAndMember() async {
    try {
      // Get the token and username
      String? token = await _authService.getAccessToken();
      String? username = await _authService.getUsernameFromToken();
      String? creatorUsername = Preferences.getGroupCreatorUsername();

      // Print the token and username for debugging
      print('Retrieved Token >>>>>>>>>>>>>>>>>>>: $token');
      print('Retrieved Username >>>>>>>>>>>>>>>>: $username');
      // Print the creator's username for debugging
      print('Retrieved Group Creator Username >>>>>>>>>: $creatorUsername');
      // Fetch the member details by username
      if (token != null && username != null) {
        final response = await _groupService.getMemberByUsername(token, widget.group.id!, context);
        // Print the response for debugging
        print('Response from getMemberByUsername >>>>>>>>>> : ${response?.body}');
        if (response != null) {
          setState(() {
            _username = username;
            _groupCreatorUsername = creatorUsername;
            currentMember = Member.fromJson(jsonDecode(response.body));
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showErrorToast(context, "Failed to load user data.");
    }
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold (
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: selectedGroup == null
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
                              arguments:selectedGroup
                          );
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),

                      if (_username == _groupCreatorUsername) ...[
                        GroupMenuCard(
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          title: 'All Contributions',
                          press: () {
                            Navigator.pushNamed(
                                context,
                                AppRoutes.allContributionsGroupScreen,
                                arguments:selectedGroup
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
                      ],
                      // My Contributions (visible to all users)
                      GroupMenuCard(
                        icon: Icons.history,
                        iconColor: Colors.orange,
                        title: 'My Contributions',
                        press: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutes.contributionGroupScreen,
                              arguments: MyArguments(selectedGroup, currentMember!)
                          );
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // My Loans (visible to all users)
                      GroupMenuCard(
                        icon: Icons.monetization_on,
                        iconColor: Colors.purple,
                        title: 'My Loans',
                        press: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutes.loanGroupScreen,
                              arguments:MyArguments(selectedGroup, currentMember!)
                          );
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
