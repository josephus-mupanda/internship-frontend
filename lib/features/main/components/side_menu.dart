import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/preferences.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/alert_widget.dart';
import '../../../data/models/user.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../data/services/auth_service.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {

  const SideMenu({super.key,}) ;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final AuthService _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final user = await getUserDetails();
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
                        // We don't want to show this close button on Desktop mood
                        if (!Responsive.isDesktop(context)) const CloseButton(),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      backgroundImage: AssetImage(ImagePath.profile),
                    ),
                    _user != null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _user!.username,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _user!.email!,
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
                        onPressed: () {},
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
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Logout",
          content: "Are you sure you want to logout?",
          nameYes: "Yes",
          nameNo: "No",
          ok: () async {
            Navigator.of(context).pop(); // Close the dialog
            await _logoutUser(); // Call logout method
          },
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
