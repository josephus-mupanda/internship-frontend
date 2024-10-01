import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internship_frontend/core/utils/images.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../main/components/side_menu.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: const SideMenu(),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
          color:Theme.of(context).cardColor,
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                  child: Row(
                    children: [
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        fit: StackFit.loose,
                        children: [
                          Center(
                            child: SingleChildScrollView(
                              child: Container(
                                height: size.height,
                                width: size.width,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                          child: Card(
                                            color: Theme.of(context).cardColor,
                                            child: Column(
                                              children: <Widget>[
                                                const SizedBox(height: Constants.kDefaultPadding / 2),
                                                Flexible(
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 300,
                                                            child:  SvgPicture.asset(
                                                              ImagePath.onBoardingImageOne,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            "Logout",
                                                            textAlign: TextAlign.center,
                                                            style: Theme.of(context).textTheme.headlineMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: Constants.kDefaultPadding
                                                          ),
                                                          Text(
                                                            "Are you sure you want to logout?",
                                                            textAlign: TextAlign.center,
                                                            style: Theme.of(context).textTheme.bodyMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: Constants.kDefaultPadding,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

}
