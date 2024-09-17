import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_frontend/core/utils/extensions.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../data/providers/menu_provider.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {

  const SideMenu({super.key,}) ;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

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
                          "assets/images/Logo Outlook.png",
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
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Josephus Mupanda",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
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
                        icon: WebsafeSvg.asset("assets/Icons/Edit.svg", width: 16),
                        label: const Text(
                          "New group",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).addNeumorphism(
                        topShadowColor: Colors.white,
                        bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(height: Constants.kDefaultPadding),
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
                              ],
                            );
                        }
                    ),
                    const SizedBox(height: Constants.kDefaultPadding * 2),
                    // Tags
                    // const Tags(),
                  ],
                ),
              ),
            ),
            const MenuItem(
              title: "Logout",
              groupValue: MenuItemSelect.LOGOUT,
              //value: selectItem,
              //onChanged: changeValue,
              icon: FeatherIcons.power,
            ),
          ],
        ),
      ),
    );
  }
}
