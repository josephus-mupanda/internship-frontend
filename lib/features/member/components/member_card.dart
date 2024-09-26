import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/data/services/user_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/member.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class MemberCard extends StatefulWidget {
  final bool isActive;
  final Member member;
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
  String? username;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }
  // Fetch the username based on member's userId
  Future<void> fetchUsername() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      //showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    final response = await _userService.getUserById(widget.member.userId!, token, context);
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        username = data['username'];
      });
    }
  }


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
                      SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor: getRandomColor(),
                          child: Text(
                              username != null ? username![0] : '?',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text : "${username ?? 'Loading...'} \n",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Join Date : ${widget.member.joinDate}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "View",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Edit",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.kDefaultPadding / 2),
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
}

