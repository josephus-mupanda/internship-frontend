import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateBasedOnPreferences(); // Check preferences and navigate accordingly
    // Timer(const Duration(seconds: 3), () {
    //   Navigator.pushReplacementNamed(context,AppRoutes.onboarding);
    // });
  }

  Future<void> _navigateBasedOnPreferences() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has seen onboarding or is logged in
    bool? hasSeenOnboarding = Preferences.getHasSeenOnboarding();
    bool? isLoggedIn = Preferences.getIsLoggedIn();

    // Decide where to navigate
    if (isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard); // Navigate to dashboard if logged in
    } else if (hasSeenOnboarding == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.login); // Navigate to login if onboarding has been seen
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding); // Navigate to onboarding by default
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Responsive(
        mobile: MobileSplashScreen(),
        tablet: TabletSplashScreen(),
        desktop: DesktopSplashScreen(),
      ),
    );
  }
}

class MobileSplashScreen extends StatelessWidget {
  const MobileSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImagePath.companyLogo,), // Replace with your logo
          const SizedBox(height: 20),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}

class TabletSplashScreen extends StatelessWidget {
  const TabletSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.companyLogo, width: 200), // Replace with your logo
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopSplashScreen extends StatelessWidget {
  const DesktopSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.companyLogo, width: 300), // Replace with your logo
            const SizedBox(height: 20),
            Text(
              "Group Contributions and Savings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground, // Use onBackground color
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Save and grow together",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7), // Use onBackground with opacity
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}