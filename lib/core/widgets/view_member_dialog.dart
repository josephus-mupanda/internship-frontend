
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../data/models/member.dart';
import '../../themes/color_palette.dart';
import '../constants/constants.dart';

class ViewMemberDialog extends StatefulWidget {

  final String title;
  final Member member;
  final String username;

  const ViewMemberDialog({
    required this.title,
    required this.member,
    required this.username,
    super.key});

  @override
  State<ViewMemberDialog> createState() => _ViewMemberDialogState();
}

class _ViewMemberDialogState extends State<ViewMemberDialog> {

  String? name, description;

  Color getRoleColor(String role) {
    if (role == 'LEADER') {
      return const Color(0xFF23CF91); // Green
    } else if (role == 'MEMBER') {
      return const Color(0xFF3A6FF7); // Blue
    }
    return Colors.grey;
  }
  // Function to get active status text color
  Color getActiveColor(bool isActive) {
    return isActive ? const Color(0xFF23CF91) : ColorPalette.errorColor;
  }

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

          CircleAvatar(
            radius: 30,
            child: Text(
              widget.username[0],
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 24
              ),
            ),
          ),
            const SizedBox(height: Constants.kDefaultPadding),
             Text('Name: ${widget.username}', style: theme.textTheme.bodyMedium,),
            const SizedBox(height: Constants.kDefaultPadding/2),
            Text('Join Date: ${widget.member.joinDate}', style: theme.textTheme.bodyMedium,),
            const SizedBox(height: Constants.kDefaultPadding/2),
            Text(
              "Active: ${widget.member.isActive  == true  ? 'Yes' : 'No'}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: getActiveColor(widget.member.isActive ?? false),
              ),
            ),
            const SizedBox(height: Constants.kDefaultPadding/2),
            Text(
              'Role: ${widget.member.roleType}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: getRoleColor(widget.member.roleType!),
              ),
            ),
            const SizedBox(height: Constants.kDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child:  TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: ColorPalette.primaryColor,
                      ),
                      onPressed:()  async {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                      label:Text(
                          "close",
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white
                          )
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



}