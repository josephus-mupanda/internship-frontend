import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/services/user_service.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/toast.dart';
import '../../../data/models/user.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class UserCard extends StatefulWidget {
  final User user;
  const UserCard({super.key,
    required this.user,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
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
                    SizedBox(
                      width: 32,
                      child: CircleAvatar(
                        backgroundColor: getRandomColor(),
                        child: Text(
                          widget.user.username[0].toUpperCase(),
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
                          text: "${widget.user.username} \n",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: ColorPalette.primaryColor,
                      ),
                      onPressed:()  async {
                        await _addMemberInTheGroup();
                      },
                      icon: const Icon(Icons.add, color:Colors.white, size: 16,),
                      label:Text(
                          "Add",
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white
                          )
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _addMemberInTheGroup() async {
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

    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during ');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }
}

