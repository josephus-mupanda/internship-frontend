import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/features/disbursement/schedule_tab.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/loading.dart';
import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/alert_widget.dart';
import '../../data/models/Schedule.dart';
import '../../data/models/group.dart';

import '../../data/models/member.dart';
import '../../data/providers/member_provider.dart';
import '../../data/providers/schedule_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/group_service.dart';
import '../../routes/app_routes.dart';
import '../../themes/color_palette.dart';
import '../group/components/header.dart';
import 'members_received_tab.dart';
import 'members_to_receive_tab.dart';

class DisbursementScreen extends StatefulWidget {
  final Group group;
  const DisbursementScreen({super.key, required this.group});
  @override
  State<DisbursementScreen> createState() => _DisbursementScreenState();
}

class _DisbursementScreenState extends State<DisbursementScreen> with SingleTickerProviderStateMixin {
  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  String? _username;
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchUpdatedSchedule();
    fetchUpdatedMembersWhoNotReceived();
    fetchUpdatedMembersWhoReceived();
    _loadUsernameAndMember();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  /////////////////////////////////// SCHEDULE //////////////////////////////////////////

  List<Schedule> schedule = [];
  List<Schedule> filteredSchedule = [];

  Future<void> fetchUpdatedSchedule() async {
    String? token = await _authService.getAccessToken();
    if (token == null ) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      final response = await _groupService.getAutomatedDisbursement(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<Schedule> fetchedSchedule = data.map((scheduleJson) {
          return Schedule.fromJson(scheduleJson);
        }).toList();
        setState(() {
          schedule = fetchedSchedule;
          filteredSchedule = schedule;
          Provider.of<ScheduleProvider>(context, listen: false).setSchedule(schedule);
        });
      } else {
        showErrorToast(context, "Failed to fetch schedule. Status Code: ${response?.statusCode}");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
    }
  }

  ///////////////////////////////////// MEMBERS WHO RECEIVED ////////////////////////////////////////
  List<MyMember> members = [];
  List<MyMember> filteredMembers = [];

  Future<void> fetchUpdatedMembersWhoReceived() async {
    String? token = await _authService.getAccessToken();
    if (token == null ) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      final response = await _groupService.getMembersWhoReceived(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<MyMember> fetchedMembers = data.map((membersJson) {
          return MyMember.fromJson(membersJson);
        }).toList();
        setState(() {
          members = fetchedMembers;
          filteredMembers = members;
          Provider.of<MemberProvider>(context, listen: false).setMembersReceived(members);
        });
      } else {
        showErrorToast(context, "Failed to fetch members. Status Code: ${response?.statusCode}");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
    }
  }

  ///////////////////////////////////////MEMBERS WHO  NOT RECEIVED //////////////////////////////////////////////
  Future<void> fetchUpdatedMembersWhoNotReceived() async {
    String? token = await _authService.getAccessToken();
    if (token == null ) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      final response = await _groupService.getMembersWhoNotReceived(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<MyMember> fetchedMembers = data.map((membersJson) {
          return MyMember.fromJson(membersJson);
        }).toList();
        setState(() {
          members = fetchedMembers;
          filteredMembers = members;
          Provider.of<MemberProvider>(context, listen: false).setMembersToReceive(members);
        });
      } else {
        showErrorToast(context, "Failed to fetch members. Status Code: ${response?.statusCode}");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
    }
  }

  // Fetch the username from the token
  Future<void> _loadUsernameAndMember() async {
    try {
      String? token = await _authService.getAccessToken();
      String? username = await _authService.getUsernameFromToken();
      int? userId =  Preferences.getUserId();

      if (token != null && username != null  && userId != null ) {
        final response = await _groupService.getMemberByUsername(token, widget.group.id!, userId, context);
        if (response != null) {
          setState(() {
            _username = username;
          });
        }
      }
    } catch (error) {
      setState(() {
      });
      showErrorToast(context, "Failed to load user data.");
    }
  }
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body:  Container(
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
                      group: widget.group,
                    ),
                    // Members Who Received Tab
                    MembersReceivedTab(
                      group: widget.group,
                    ),
                    // Members Who Have to Receive Tab
                    MembersToReceiveTab(
                      group: widget.group,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (_username == widget.group.createdBy)
          ?
      InkWell(
        onTap: () {
          _showAutomationDialog();
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor,
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

  void _showAutomationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Automate Disbursement",
          content: "Are you sure you want to automate disbursement in this group?",
          nameYes: "automate",
          nameNo: "Cancel",
          ok: () async {
            Navigator.of(context).pop();
            await _automateDisbursement();
          },
        );
      },
    );
  }

  Future<void> _automateDisbursement() async {
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    // Show loading dialog
    showLoadingDialog(context);
    try {
      // Call the automateDisbursement function from GroupService
      final response = await _groupService.automateDisbursement(widget.group.id!, token, context);
      if (response != null && response.statusCode == 200) {
        await fetchUpdatedSchedule();
        await fetchUpdatedMembersWhoReceived();
        await fetchUpdatedMembersWhoNotReceived();
        // Set disbursement status to true after successful automation
        await Preferences.setDisbursementStatus(true);
        showSuccessToast(context, 'Automated disbursement schedule retrieved successfully.');
      }
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during this process');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }

}






