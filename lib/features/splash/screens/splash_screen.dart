import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward(); // Start the animation on load

    _navigateBasedOnPreferences(); // Check preferences and navigate accordingly
  }

  Future<void> _navigateBasedOnPreferences() async {
    // Wait for 1 seconds
    await Future.delayed(const Duration(seconds: 1));

    // Check if user has seen onboarding or is logged in
    bool? hasSeenOnboarding = Preferences.getHasSeenOnboarding();
    bool? isLoggedIn = Preferences.getIsLoggedIn();

    // Decide where to navigate
    if (isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (hasSeenOnboarding == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Responsive(
        mobile: MobileSplashScreen( controller :_controller),
        tablet: TabletSplashScreen(controller: _controller,),
        desktop: DesktopSplashScreen(controller: _controller,),
      ),
    );
  }
}

class MobileSplashScreen extends StatelessWidget {
  final AnimationController controller;
  const MobileSplashScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.companyLogo,), // Replace with your logo
            const SizedBox(height: Constants.kDefaultPadding),
            SizedBox(
              width: 250,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: controller.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor
                    ),
                    backgroundColor:  Theme.of(context).cardColor,
                  );
                },
              ),
            ),
            // CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>( Theme.of(context).primaryColor),
            // ),
          ],
        ),
      ),
    );
  }
}

class TabletSplashScreen extends StatelessWidget {
  final AnimationController controller;
  const TabletSplashScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.companyLogo, width: 200), // Replace with your logo
            const SizedBox(height: Constants.kDefaultPadding * 1.5),
            SizedBox(
              width: 250,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: controller.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor
                    ),
                    backgroundColor:  Theme.of(context).cardColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopSplashScreen extends StatelessWidget {
  final AnimationController controller;
  const DesktopSplashScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.companyLogo, width: 300), // Replace with your logo
            const SizedBox(height: Constants.kDefaultPadding),
            Text(
              "Group Contributions and Savings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground, // Use onBackground color
              ),
            ),
            const SizedBox(height: Constants.kDefaultPadding/2),
            Text(
              "Save and grow together",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7), // Use onBackground with opacity
              ),
            ),
            const SizedBox(height: Constants.kDefaultPadding * 1.5),
            SizedBox(
              width: 250,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: controller.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor
                    ),
                    backgroundColor:  Theme.of(context).cardColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}