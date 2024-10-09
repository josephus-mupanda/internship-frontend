import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/data/services/user_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/alert_widget.dart';
import '../../../core/widgets/view_member_dialog.dart';
import '../../../data/models/member.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class MemberCard extends StatefulWidget {
  final bool isActive;
  final MyMember member;
  final VoidCallback? press;
  final VoidCallback? onMemberDeleted;

  const MemberCard({super.key,
    this.isActive = true,
    required this.member,
    this.press,
    this.onMemberDeleted
  });

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {

  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

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
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kDefaultPadding / 2),
      child: InkWell(
        onTap: widget.press,
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
                        // backgroundColor: getRandomColor(),
                        radius : 30,
                        child: Text(
                            widget.member.user![0],
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text : "${widget.member.user} \n",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Join Date : ${widget.member.joinDate}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon:Icon(Icons.visibility,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                            onPressed: () {
                              // Show the member view dialog on button press
                              showDialog(
                                context: context,
                                builder: (context) => ViewMemberDialog(
                                  title: "View Member Details",
                                  member: widget.member,
                                  username: widget.member.user!,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon:Icon(Icons.exit_to_app,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                  title: "Leave the Group",
                                  content: "Are you sure you want to leave this group?",
                                  nameYes: "Yes",
                                  nameNo: "No",
                                  ok: () async {
                                    Navigator.of(context).pop(); // Close the dialog
                                    await _leaveGroup();
                                  },
                                )
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.member.isActive == true ? const Color(0xFF23CF91): ColorPalette.errorColor ,
                ),
              )
            ),
            if (widget.member.tagColor != null)
              Positioned(
                left: 8,
                top: 0,
                child: SvgPicture.asset(
                  ImagePath.badgeRole,
                  height: 18,
                  color: widget.member.tagColor,
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _leaveGroup() async {
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
      // await _groupService.deleteGroup(widget.group.id!, token, context);
      // widget.onGroupDeleted?.call();
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during deletion');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }
}

