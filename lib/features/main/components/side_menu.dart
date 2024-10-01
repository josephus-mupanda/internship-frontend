import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/group_dialog.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/preferences.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/alert_widget.dart';
import '../../../data/models/group.dart';
import '../../../data/models/user.dart';
import '../../../data/providers/group_provider.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../data/providers/theme_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/group_service.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {

  const SideMenu({super.key,}) ;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();

  User? _user;
  List<Group> groups = [];

  Future<void> fetchGroups() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    try {
      final response = await _groupService.getAllGroups(token);
      if (response.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response.body);
        // Convert the JSON data into a list of Group objects
        List<Group> fetchedGroups = data.map((groupJson) {
          return Group.fromJson(groupJson);
        }).toList();
        // Update your state or provider with the fetched groups
        setState(() {
          groups = fetchedGroups;
          // Update GroupProvider with the fetched groups
          Provider.of<GroupProvider>(context, listen: false).setGroups(groups);
        });
      } else {
        // Handle the error if the status code is not 200
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching groups: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroups();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final user = await getUserDetails();
    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
    setState(() {
      _user = user;
    });
  }

  Future<User?> getUserDetails() async {
    final username = await Preferences.getUsername();
    final email = await Preferences.getEmail();
    if (username != null && email != null) {
      return User(username: username, email: email);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context,userProvider,child){
        return Container(
          height: double.infinity,
          padding: const EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImagePath.companyLogo,
                              width: 46,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Provider.of<ThemeProvider>(context).isDarkTheme
                                    ? Icons.wb_sunny
                                    : Icons.nights_stay,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              onPressed: () {
                                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                              },
                            ),
                            const SizedBox(width: Constants.kDefaultPadding/2),
                            if (!Responsive.isDesktop(context)) CloseButton(
                              color:Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          //backgroundImage: AssetImage(ImagePath.profile),
                          child: Icon(
                            FeatherIcons.user,
                            size: 40,
                            color:Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        //_user != null ?
                        userProvider.user != null ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                             // _user!.username,
                              userProvider.user!.username,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              //_user!.email!,
                              userProvider.user!.email!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ) : Text(
                          'Loading...',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                        SizedBox(
                            width: double.infinity,
                            child:  TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: ColorPalette.primaryColor, // Use backgroundColor instead of color
                                //foregroundColor: kTextColor, // Set the text color here
                              ),
                              onPressed: () {
                                _showGroupDialog();
                              },
                              icon: const Icon( FeatherIcons.edit, color:Colors.white, size: 16,),
                              label: const Text(
                                "Create a group",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                        ),
                        const SizedBox(height: Constants.kDefaultPadding * 2),
                        Consumer<MenuProvider>(
                            builder: (context, menuProvider, child) {
                              return Column(
                                children: [
                                  MenuItem(
                                    title: "Groups",
                                    groupValue: MenuItemSelect.GROUPS,
                                    value: menuProvider.selectedItem,
                                    onChanged: (value) {
                                      menuProvider.selectItem(MenuItemSelect.GROUPS);
                                    },
                                    icon: FeatherIcons.users,
                                  ),
                                  MenuItem(
                                    title: "Loans",
                                    groupValue: MenuItemSelect.LOANS,
                                    value: menuProvider.selectedItem,
                                    onChanged: (value) {
                                      menuProvider.selectItem(MenuItemSelect.LOANS);
                                    },
                                    icon: FontAwesomeIcons.wallet,
                                  ),
                                  MenuItem(
                                    title: "Transactions",
                                    groupValue: MenuItemSelect.TRANSACTIONS,
                                    value: menuProvider.selectedItem,
                                    onChanged:(value) {
                                      menuProvider.selectItem(MenuItemSelect.TRANSACTIONS);
                                    },
                                    icon: FeatherIcons.creditCard,
                                  ),
                                  MenuItem(
                                    title: "Profile",
                                    groupValue: MenuItemSelect.PROFILE,
                                    value: menuProvider.selectedItem,
                                    onChanged: (value) {
                                      menuProvider.selectItem(MenuItemSelect.PROFILE);
                                    },
                                    icon: FeatherIcons.user,
                                  ),
                                  MenuItem(
                                    title: "Logout",
                                    groupValue: MenuItemSelect.LOGOUT,
                                    value: menuProvider.selectedItem,
                                    onChanged: (value) async {
                                      menuProvider.selectItem(MenuItemSelect.LOGOUT);
                                      _showLogoutDialog();
                                    },
                                    icon: FeatherIcons.power,
                                  ),
                                ],
                              );
                            }
                        ),
                        const SizedBox(height: Constants.kDefaultPadding * 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  GroupDialog(
          title: "Create Group",
          content: "Please enter the group details below:",
          nameYes: "Create",
          nameNo: "Cancel",
          onGroupCreated: () {
            fetchGroups();
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: MyLogoutDialog(
            title: "Logout",
            content: "Are you sure you want to logout?",
            nameYes: "Yes",
            nameNo: "No",
            ok: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _logoutUser(); // Call logout method
            },
          ),
        );
      },
    );
  }
  Future<void> _logoutUser() async {
    // Show loading dialog
    showLoadingDialog(context);
    try {
      await _authService.logout(context);
      // Reset MenuProvider selection after logout
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      menuProvider.resetSelection();
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during logout');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.pushReplacementNamed(context, AppRoutes.login); // Navigate to login screen
    }
  }
}
