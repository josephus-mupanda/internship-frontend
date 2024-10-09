import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart';
import 'package:internship_frontend/data/models/member.dart';
import 'package:internship_frontend/data/services/auth_service.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/preferences.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/alert_widget.dart';
import '../../../data/models/group.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../routes/app_routes.dart';

class GroupCard extends StatefulWidget {
  final bool isActive;
  final Group group;
  final VoidCallback? press;
  final VoidCallback? onGroupDeleted;

  const GroupCard({super.key,
    this.isActive = true,
    required this.group,
    this.press,
    this.onGroupDeleted,
  });
  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {

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
              color: widget.isActive ? ColorPalette.primaryColor : Theme.of(context).colorScheme.background,
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
                        widget.group.name[0].toUpperCase(),
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
                          text: "${widget.group.name} \n",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.isActive ? Colors.white : null,
                          ),
                          children: [
                            TextSpan(
                              text: "Created by : ${widget.group.createdBy}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: widget.isActive ? Colors.white : null,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                    ),
                    if (currentUsername == widget.group.createdBy) ...[
                      Column(
                        children: [
                          IconButton(
                              onPressed: (){

                              },
                              icon: Icon(
                                FeatherIcons.edit,
                                color: widget.isActive ? Colors.white70 : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              )
                          ),
                          const SizedBox(height: 5),
                          IconButton(
                              onPressed: (){
                                _showDeleteGroupDialog();
                              },
                              icon: Icon(
                                FeatherIcons.trash,
                                color: widget.isActive ? Colors.white70 : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              )
                          ),

                        ],
                      ),
                      const SizedBox(width: Constants.kDefaultPadding / 2),
                    ],
                    if (widget.group.isInGroup)
                      InkWell(
                        onTap: (){
                          menuProvider.selectGroup( widget.group);
                          if(Responsive.isMobile(context)) {
                            Navigator.pushNamed(context,
                              AppRoutes.groupMenuScreen,
                              arguments: widget.group,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.isActive ? ColorPalette.secondaryColor : ColorPalette.errorColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              "Open Group",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white
                              )
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: (){
                          _showJoinGroupDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.isActive ? ColorPalette.secondaryColor : ColorPalette.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Text(
                              "Join Group",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white
                              )
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Constants.kDefaultPadding / 2),
                Text(
                  widget.group.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    color: widget.isActive ? Colors.white70 : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  void _showDeleteGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Delete Group",
          content: "Are you sure you want to delete this group?",
          nameYes: "Yes",
          nameNo: "No",
          ok: () async {
            Navigator.of(context).pop(); // Close the dialog
            await _deleteGroup(); // Call logout method
          },
        );
      },
    );
  }
  void _showJoinGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Join Group",
          content: "Are you sure you want to join this group?",
          nameYes: "Join",
          nameNo: "Cancel",
          ok: () async {
            Navigator.of(context).pop();
            await _joinGroup();
          },
        );
      },
    );
  }

  Future<void> _deleteGroup() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    // Show loading dialog
    showLoadingDialog(context);
    try {
      await _groupService.deleteGroup(widget.group.id!, token, context);
      widget.onGroupDeleted?.call();
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during deletion');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }
  Future<void> _joinGroup() async {
    //final menuProvider = Provider.of<MenuProvider>(context);
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    int? userId  = Preferences.getUserId();
    if (token == null && userId == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    Member member = Member(
      userId: userId,
    );

    // Show loading dialog
    showLoadingDialog(context);
    try {
      bool? hasDisbursement = Preferences.getDisbursementStatus() ?? false;
      final Response? response;
      if (!hasDisbursement) {
        response = await _groupService.addNewMemberBeforeRotation(widget.group.id!, member, token!, context);

      } else {
        response = await _groupService.addNewMemberAfterRotation(widget.group.id!, member, token!, context);
      }
      if (response != null && response.statusCode == 201) {
        showSuccessToast(context, "Member joined successfully!");
        widget.group.isInGroup = true;
      } else {
        // Handle errors inside the add functions
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred during this process');
    } finally {
      Navigator.of(context).pop(true);
    }
  }
}
