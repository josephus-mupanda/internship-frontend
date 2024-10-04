import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:internship_frontend/core/widgets/button_widget.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../data/services/user_service.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String token;

  const ConfirmEmailScreen({required this.token, super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {

  String message = '';
  bool isLoading = true;
  final _userService = UserService(); // Initialize UserService

  @override
  void initState() {
    super.initState();
    _confirmEmail();
  }

  Future<void> _confirmEmail() async {
    try {
      final response = await _userService.confirmUser(widget.token);
      final responseBody = jsonDecode(response.body);
      String message = responseBody['message'] ?? 'An error occurred';

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          this.message = message;
        });
      } else {
        setState(() {
          isLoading = false;
          this.message = message;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = 'An unexpected error occurred'; // Handle unexpected errors
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: MobileConfirmEmailScreen(message: message, isLoading: isLoading),
        tablet: TabletConfirmEmailScreen(message: message, isLoading: isLoading),
        desktop: DesktopConfirmEmailScreen(message: message, isLoading: isLoading),
      ),
    );
  }
}

class MobileConfirmEmailScreen extends StatelessWidget {
  final String message;
  final bool isLoading;

  const MobileConfirmEmailScreen({required this.message, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath.companyLogo,
            width: 100, // Adjust as needed
          ),
          const SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
          )
              : Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 30),
          if (!isLoading)
            AppButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              text: 'Go to Login',
            ),
        ],
      ),
    );
  }
}

class TabletConfirmEmailScreen extends StatelessWidget {
  final String message;
  final bool isLoading;

  const TabletConfirmEmailScreen({required this.message, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImagePath.companyLogo,
              width: 200, // Adjust as needed
            ),
            const SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
            )
                : Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 40),
            if (!isLoading)
              AppButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                text: 'Go to Login',
              ),
          ],
        ),
      ),
    );
  }
}

class DesktopConfirmEmailScreen extends StatelessWidget {
  final String message;
  final bool isLoading;

  const DesktopConfirmEmailScreen({required this.message, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImagePath.companyLogo,
              width: 300, // Adjust as needed
            ),
            const SizedBox(height: 40),
            isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
            )
                : Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 50),
            if (!isLoading)
              AppButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                text: 'Go to Login',
              ),
          ],
        ),
      ),
    );
  }
}

