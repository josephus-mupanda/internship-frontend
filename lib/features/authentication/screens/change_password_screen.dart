import 'package:flutter/material.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../onboarding/screens/page_right_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? newPassword, confirmNewPassword;

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(maxWidth: Constants.kMaxWidth ?? double.infinity),
        child: SafeArea(
          child: Column(
            children: [
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
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(Constants.kDefaultPadding / 2),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset('assets/images/reset-password.png'),
                                            Text(
                                              'Change Password',
                                              style: theme.textTheme.headlineLarge?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            InputWidget(
                                              obscureText: !showPassword,
                                              hintText: 'Enter New Password',
                                              prefixIcon: Icons.lock,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  showPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    showPassword = !showPassword;
                                                  });
                                                },
                                              ),
                                              onChanged: (String? value) => newPassword = value!,
                                              validator: (String? value) {
                                                return value!.isEmpty
                                                    ? "Field is required"
                                                    : value.length < 6
                                                    ? "Password must be at least 6 characters"
                                                    : null;
                                              },
                                            ),
                                            InputWidget(
                                              obscureText: !showConfirmPassword,
                                              hintText: 'Confirm New Password',
                                              prefixIcon: Icons.lock,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  showConfirmPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    showConfirmPassword = !showConfirmPassword;
                                                  });
                                                },
                                              ),
                                              onChanged: (String? value) => confirmNewPassword = value!,
                                              validator: (String? value) {
                                                return value!.isEmpty
                                                    ? "Field is required"
                                                    : value.length < 6
                                                    ? "Password must be at least 6 characters"
                                                    : value != newPassword
                                                    ? "Passwords do not match"
                                                    : null;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () {
                                                // Handle the password change logic
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  AppRoutes.login,
                                                );
                                              },
                                              child: Container(
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  color: theme.primaryColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 20),
                                                child: Center(
                                                  child: Text(
                                                    'Change Password',
                                                    style: theme.textTheme.labelLarge?.copyWith(
                                                      color: theme.colorScheme.onPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Only show the right-side panel on desktop screens
                                  if (Responsive.isDesktop(context))
                                    const PageRightSide(
                                      title: "Dear user,\n  explore these onboarding screens. 🤝",
                                      icon: "assets/images/svg/register.svg",
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
