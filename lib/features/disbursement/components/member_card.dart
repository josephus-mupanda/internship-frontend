import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/services/user_service.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/view_member_dialog.dart';
import '../../../data/models/member.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class MemberCard extends StatefulWidget {
  final Member member;

  const MemberCard({super.key, required this.member,});

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

  Future<void> fetchUsername() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    try {
      // Make the API call to get the user details by ID
      final response = await _userService.getUserById(widget.member.userId!, token, context);

      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          username = data['username'];
        });
      } else {
        // Log the error response
        print('Failed to fetch username for userId ${widget.member.userId}. Status code: ${response?.statusCode}');
      }
    } catch (e) {
      // Log any errors that occur during the fetch
      print('Error fetching username for userId ${widget.member.userId}: $e');
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
                          username != null ? username![0] : '?',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.kDefaultPadding / 2),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text : "${username ?? 'Loading...'} \n",
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
                                username: username!,
                              ),
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
        ],
      ),
    );
  }
}

