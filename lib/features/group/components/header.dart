import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/core/constants/constants.dart';

import '../../../core/layout/responsive_widget.dart';
import '../../../data/models/group.dart';
import '../../../data/services/auth_service.dart';
import '../../../themes/color_palette.dart';

class GroupHeader extends StatelessWidget {

  final Group group;
  final AuthService _authService = AuthService();

  GroupHeader({super.key, required this.group});

  Future<void> _showGroupPopup(BuildContext context, String username) async {
    bool isCreator = username == group.createdBy;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Text(
                  group.name.isNotEmpty
                      ? group.name[0].toUpperCase()
                      : 'G',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: Constants.kDefaultPadding),
              Text(group.name ?? "No Name"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description: ${group.description ?? "No description"}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Created by: ${group.createdBy ?? 'Unknown'}",
                  style: Theme.of(context).textTheme.bodyMedium,
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
                            backgroundColor: ColorPalette.errorColor,
                          ),
                          onPressed:()  async {

                          },
                          icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                          label:Text(
                          "Exit group",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white
                              )
                          ),
                        )
                    ),
                    if (isCreator)
                      const SizedBox(
                        width: Constants.kDefaultPadding/2,
                      ),
                    if (isCreator)
                      Expanded(
                          child:  TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: ColorPalette.primaryColor,
                              // foregroundColor: kTextColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                            label: Text(
                              "Edit group",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(

        future: _authService.getUsernameFromToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const  CircularProgressIndicator();
          }

          String username = snapshot.data ?? '';
          return InkWell(
            onTap: () => _showGroupPopup(context, username),
            child: Padding(
              padding: const EdgeInsets.all(Constants.kDefaultPadding),
              child: Row(
                children: [
                  if (Responsive.isMobile(context)) BackButton(
                    color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  CircleAvatar(
                    radius: 25,
                    child: Text(
                      group.name.isNotEmpty
                          ? group.name[0].toUpperCase()
                          : 'G',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: Constants.kDefaultPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name ?? "No Name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Created by: ${group.createdBy ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        }
    );
  }
}
