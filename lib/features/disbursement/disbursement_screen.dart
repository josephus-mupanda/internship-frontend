import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/Schedule.dart';
import 'package:internship_frontend/features/disbursement/components/member_card.dart';
import 'package:internship_frontend/features/disbursement/components/schedule_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/toast.dart';
import '../../data/models/group.dart';

import '../../data/models/member.dart';
import '../../data/providers/member_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/group_service.dart';
import '../../routes/app_routes.dart';
import '../../themes/color_palette.dart';
import '../group/components/header.dart';

class DisbursementScreen extends StatefulWidget {
  final Group group;

  const DisbursementScreen({super.key, required this.group,});

  @override
  State<DisbursementScreen> createState() => _DisbursementScreenState();
}

class _DisbursementScreenState extends State<DisbursementScreen> with SingleTickerProviderStateMixin {
  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<Member> members = [];
  List<Member> filteredMembers = [];
  String? username;

  late TabController _tabController;


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

  @override
  void initState() {
    super.initState();
    widget.group;
    fetchMembers();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _onRefresh() async {
    fetchMembers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

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
                  "Disbursement In this Group",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                // CREATE TABS HERE
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Schedule"),
                    Tab(text: "Members Who Received"),
                    Tab(text: "Members Who Have to Receive"),
                  ],
                  labelColor: ColorPalette.primaryColor,
                  // unselectedLabelColor: Colors.grey,
                  indicatorColor: ColorPalette.secondaryColor,
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Schedule Tab
                      ScheduleTab(
                        members: members,
                        group: widget.group,
                      ),
                      // Members Who Received Tab
                      MembersReceivedTab(members: members),
                      // Members Who Have to Receive Tab
                      MembersToReceiveTab(members: members),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: (username == widget.group.createdBy)
          ?
      InkWell(
        onTap: () {
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: ColorPalette.secondaryColor,
              borderRadius: BorderRadius.circular(Constants.kDefaultPadding/2),
            ),
            child: Text(
            "Automate",
              style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white
              )
            )
        )
      )
          :
      null,
    );
  }
}

class ScheduleTab extends StatelessWidget {
  final List<Member> members;
  final Group group;

  const ScheduleTab({super.key, required this.members, required this.group});

  @override
  Widget build(BuildContext context) {
    // Implement your Schedule logic here
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return ScheduleCard(
          group: group,
          schedule: Schedule(month: "september", memberUsername: "josephus", amount: 100),
        );
      },
    );
  }
}

class MembersReceivedTab extends StatelessWidget {
  final List<Member> members;

  const MembersReceivedTab({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    // Implement your logic to show members who have received disbursements
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return MemberCard(member: members[index]);
      },
    );
  }
}

class MembersToReceiveTab extends StatelessWidget {
  final List<Member> members;

  const MembersToReceiveTab({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    // Implement your logic to show members who have to receive disbursements
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return MemberCard(member: members[index]);
      },
    );
  }
}

