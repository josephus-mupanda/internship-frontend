
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/providers/member_provider.dart';
import 'package:internship_frontend/data/providers/menu_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/providers/group_provider.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import 'components/header.dart';
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

  Future<void> fetchMembers() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    // try {
    //   final response = await _groupService.getMembersByGroup(widget.group.id!, token, context);
    //   if (response?.statusCode == 200) {
    //     // // Decode the JSON data
    //     List<dynamic> data = jsonDecode(response!.body);
    //     print(" DATA ############ $data");
    //     // Convert the JSON data into a list of Member objects
    //     List<Member> fetchedMembers = data.map((membersJson) {
    //       return Member.fromJson(membersJson);
    //     }).toList();
    //     // Update your state or provider with the fetched members
    //     setState(() {
    //       members = fetchedMembers;
    //       Provider.of<MemberProvider>(context, listen: false).setMembers(members);
    //     });
    //   } else {
    //     print("Response error: ${response?.statusCode}");
    //   }
    // } on FormatException {
    //   print("JSON Format Error: Check the structure of your response.");
    // } catch (e) {
    //   print("Error: $e");
    // }
  }

  @override
  void initState() {
    super.initState();
    // Print the group ID to check if it's being passed correctly
    print("Fetching members for group ID ################### : ${widget.group.id!}");
    fetchMembers();
  }

  void _onMemberDeleted() {
    // Refresh the list after deletion
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final selectedGroup = menuProvider.selectedGroup ?? widget.group;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              MemberHeader(group: selectedGroup),
              const Divider(thickness: 1),
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
                        onChanged: (String? value) {},
                        validator: (String? value) {},
                      ),
                    ),
                  ],
                ),
              ),
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
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Constants.kDefaultPadding),
                  child: Column(
                    children: [
                      // This is our Search bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add), // Customize the FAB color as needed
    ),
    );
  }
}
