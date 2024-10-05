import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/Schedule.dart';
import 'package:internship_frontend/data/services/auth_service.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/preferences.dart';
import '../../../data/models/group.dart';
import '../../../data/providers/menu_provider.dart';

class ScheduleCard extends StatefulWidget {

  final Group group;
  final Schedule schedule;
  const ScheduleCard({super.key,
    required this.group,
    required this.schedule
  });
  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  bool? isInGroup; // Nullable variable to track membership status
  bool isLoading = true; // To show loading indicator while checking status
  String? currentUsername;

  // Function to generate a random color
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red value
      random.nextInt(256), // Green value
      random.nextInt(256), // Blue value
    );
  }

  // Function to check membership status with error handling
  Future<void> checkMembershipStatus() async {
    try {
      // Retrieve the token and userId
      String? token = await _authService.getAccessToken();
      int? userId = Preferences.getUserId();

      if (token != null && userId != null) {
        bool result = await _groupService.isUserInGroup(widget.group.id!, userId, token, context);
        currentUsername = await _authService.getUsernameFromToken();
        setState(() {
          isInGroup = result;
          isLoading = false;
        });
      } else {
        print('No valid token found');
      }
    } catch (e) {
      print('Error checking membership status: $e');
      setState(() {
        isInGroup = false; // Default to false if error occurs
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkMembershipStatus();
  }


  @override
  Widget build(BuildContext context) {

    final menuProvider = Provider.of<MenuProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kDefaultPadding / 2),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.kDefaultPadding),
            decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      // backgroundColor: getRandomColor(),
                      child: Text(
                        widget.schedule.memberUsername[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.kDefaultPadding / 2),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "${widget.schedule.memberUsername} \n",
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: "Amount : ${widget.schedule.amount}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorPalette.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          widget.schedule.month,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white
                          )
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
