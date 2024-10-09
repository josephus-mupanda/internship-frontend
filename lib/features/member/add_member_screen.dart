
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/providers/user_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/features/group/components/header.dart';
import 'package:internship_frontend/features/member/components/user_card.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/models/user.dart';
import '../../data/providers/member_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../routes/app_routes.dart';

class AddMemberScreen extends StatefulWidget {
  final Group group;

  const AddMemberScreen({super.key, required this.group,});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {

  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();

  List<User> users = [];
  List<User> filteredUsers = [];

  Future<void> fetchUsers() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {

      final response = await _userService.getAllUsers(token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<User> fetchedUsers = data.map((usersJson) {
          return User.fromJson(usersJson);
        }).toList();
        setState(() {
          users = fetchedUsers;
          filteredUsers = users;
          Provider.of<UserProvider>(context, listen: false).setUsers(users);
        });
        await _recheckMembershipStatus();
      } else {
        showErrorToast(context, "Failed to fetch users. Status Code: ${response?.statusCode}");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
    }
  }

  void sortGroupsByUsername(bool ascending) async {
    setState(() {
      filteredUsers.sort((a, b) {
        return ascending ? a.username.compareTo(b.username) : b.username.compareTo(a.username);
      });
    });

    showSuccessToast(context, ascending ? 'Sorted by ascending username' : 'Sorted by descending username');
    // Recheck membership status after sorting
    await _recheckMembershipStatus();
  }

  void filterUsers(String query) async {
    setState(() {
      filteredUsers = users.where((user) {
        return user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.email!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
    // Recheck membership status after filtering
    await _recheckMembershipStatus();
  }

  Future<void> _recheckMembershipStatus() async {
    for (User user in filteredUsers) {
      await _checkUserInGroup(user);
    }
  }

  Future<void> _checkUserInGroup(User user) async {
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      bool isInGroup = await _groupService.isUserInGroup(widget.group.id!, user.id!, token, context);
      if (mounted) {
        setState(() {
          // Update each user's membership status
          user.isInGroup = isInGroup;
        });
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred while checking membership.');
    }
  }

  @override
  void initState() {
    super.initState();
    widget.group;
    fetchUsers();
  }

  Future<void> _onRefresh() async {
    await fetchUsers();
  }
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          color: theme.colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                GroupHeaderWithArrow(group: widget.group),
                const Divider(thickness: 1),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                  child: Row(
                    children: [
                      if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                      Expanded(
                        child: InputWidget(
                          hintText: 'Search user here...',
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
                            filterUsers(value ?? "");
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
                        "Sort by username",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_upward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        onPressed: () {
                          sortGroupsByUsername(true); // Ascending
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        onPressed: () {
                          sortGroupsByUsername(false); // Descending
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                          user: filteredUsers[index],
                          group: widget.group,
                          onUserAdded: (){
                            fetchUsers();
                          },
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
