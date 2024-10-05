
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/providers/member_provider.dart';
import 'package:internship_frontend/data/providers/menu_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/features/group/components/header.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../routes/app_routes.dart';
import 'components/member_card.dart';

class MemberScreen extends StatefulWidget {
  final Group group;

  const MemberScreen({super.key, required this.group,});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<Member> members = [];
  List<Member> filteredMembers = [];
  String? username;

  Future<void> fetchMembers() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    username = await _authService.getUsernameFromToken();

    if (token == null && username == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    try {
      final response = await _groupService.getMembersByGroup(widget.group.id!, token!, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<Member> fetchedMembers = data.map((membersJson) {
          return Member.fromJson(membersJson);
        }).toList();

        // Log the fetched members for debugging
        // Convert each member to JSON and log it
        List<Map<String, dynamic>> memberJsonList = fetchedMembers.map((member) => member.toJson()).toList();
        print('Retrieved members ############ : $memberJsonList');

        setState(() {
          members = fetchedMembers;
          filteredMembers = members;
          Provider.of<MemberProvider>(context, listen: false).setMembers(members);
        });
      } else {
        showErrorToast(context, "Failed to fetch members. Status Code: ${response?.statusCode}");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
    }
  }
  void sortGroupsByDate(bool ascending) {
    setState(() {
      filteredMembers.sort((a, b) {
        if (a.joinDate == null && b.joinDate == null) return 0; // Both are null
        if (a.joinDate == null) return ascending ? 1 : -1; // a is null, b is not
        if (b.joinDate == null) return ascending ? -1 : 1; // b is null, a is not
        return ascending ? a.joinDate!.compareTo(b.joinDate!) : b.joinDate!.compareTo(a.joinDate!);
      });
    });
    showSuccessToast(context, ascending ? 'Sorted by ascending date' : 'Sorted by descending date');
  }

  @override
  void initState() {
    super.initState();
    widget.group;
    fetchMembers();
  }

  void _onMemberDeleted() {
    // Refresh the list after deletion
    fetchMembers();
  }
  Future<void> _onRefresh() async {
    await fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body:  RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          color: theme.colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                GroupHeaderWithArrow(group: widget.group),
                const Divider(thickness: 1),
                Text(
                  "All Members in this group",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                  child: Row(
                    children: [
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
                          onChanged: (String? value) {
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
                  child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        Member member = members[index];
                        return MemberCard(
                          member: member,
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: (username == widget.group.createdBy)
          ?
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.addMemberInGroupScreen,
                arguments: widget.group,
              );
            },
            child: const Icon(Icons.add),
          )
              :
      null,
    );
  }
}
