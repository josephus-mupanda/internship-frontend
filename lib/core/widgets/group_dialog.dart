
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/services/auth_service.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';
import '../../themes/color_palette.dart';
import '../constants/constants.dart';
import '../utils/loading.dart';
import '../utils/preferences.dart';
import '../utils/toast.dart';
import 'input_widget.dart';

class GroupDialog extends StatefulWidget {

  final String title;
  final String content;
  final String nameYes;
  final String nameNo;
  final VoidCallback onGroupCreated;

  const GroupDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    required this.onGroupCreated,
    super.key});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _groupService = GroupService();
  final _authService = AuthService();
  String? name, description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
        backgroundColor: theme.cardColor,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: Constants.kDefaultPadding / 2),
              Text( widget.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.content,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: Constants.kDefaultPadding/2,
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputWidget(
                      obscureText: false,
                      hintText: 'Enter Group Name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.group,
                      onChanged: (String? value) => name = value!,
                      validator: (String? value) => value!.isEmpty ? "Group name is required" : null,
                    ),
                    InputWidget(
                      obscureText: false,
                      hintText: 'Enter Group Description',
                      maxLines: 2,
                      prefixIcon: Icons.description,
                      onChanged: (String? value) => description = value!,
                      validator: (String? value) => value!.isEmpty ? "Description is required" : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Constants.kDefaultPadding/2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child:  TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: ColorPalette.primaryColor,
                          //foregroundColor: kTextColor, // Set the text color here
                        ),
                        onPressed:()  async {
                          if (formKey.currentState?.validate() ?? false) {
                            await _createGroup();
                          }
                        },
                        icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                        label:Text(
                            widget.nameYes,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white
                            )
                        ),
                      )
                  ),
                  const SizedBox(
                    width: Constants.kDefaultPadding/2,
                  ),
                  Expanded(
                      child:  TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: theme.colorScheme.background,
                          // foregroundColor: kTextColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                        label: Text(
                          widget.nameNo,
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
  Future<void> _createGroup() async {
    final Group group = Group(
        name: name!,
        description: description!
    );
    // Show loading dialog
    showLoadingDialog(context);

    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();

    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      // Retrieve the username from AuthService or other method
      String? username = await _authService.getUsernameFromToken();
      if (username != null) {
        await Preferences.setGroupCreatorUsername(username);
      }
      final response = await _groupService.createGroup(group,token,context);

      Group newGroup = Group.fromJson(jsonDecode(response!.body));
      formKey.currentState?.reset();
      setState(() {
        name = null;
        description = null;
      });

      Provider.of<GroupProvider>(context, listen: false).setGroups([...Provider.of<GroupProvider>(context, listen: false).groups, newGroup]);
      widget.onGroupCreated();
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during creation');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.of(context).pop();
    }
  }
}