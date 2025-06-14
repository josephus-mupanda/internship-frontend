import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/preferences.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/alert_widget.dart';
import '../../../data/models/group.dart';
import '../../../data/models/member.dart';
import '../../../data/models/user.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Group group;
  final VoidCallback onUserAdded;
  const UserCard({super.key,
    required this.user, required this.group, required this.onUserAdded,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

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
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kDefaultPadding / 2),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.kDefaultPadding),
            decoration: BoxDecoration(
              color:Theme.of(context).cardColor,
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
                        widget.user.username[0].toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.kDefaultPadding / 2),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "${widget.user.username} \n",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "${widget.user.email}",
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                    ),
                    if (widget.user.isInGroup)
                      const SizedBox()
                    else
                      InkWell(
                        onTap: (){
                          _showAddMemberInGroupDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Add",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white
                              )
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showAddMemberInGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Add Member",
          content: "Are you sure you want to add this member in this group?",
          nameYes: "Add",
          nameNo: "Cancel",
          ok: () async {
            Navigator.of(context).pop();
            await _addMember();
          },
        );
      },
    );
  }

  Future<void> _addMember() async {
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    Member member = Member(
      userId: widget.user.id!,
    );
    // Show loading dialog
    showLoadingDialog(context);
    try {
      bool? hasDisbursement = Preferences.getDisbursementStatus() ?? false;
      final Response? response;
      if (!hasDisbursement) {
        response = await _groupService.addNewMemberBeforeRotation(widget.group.id!, member, token, context);
      } else {
        response = await _groupService.addNewMemberAfterRotation(widget.group.id!, member, token, context);
      }
      if (response != null && response.statusCode == 201) {
        showSuccessToast(context, "Member added successfully!");
        widget.onUserAdded();
      } else {
        // Handle errors inside the add functions
      }
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during this process');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.of(context).pop(true);
    }
  }
}

